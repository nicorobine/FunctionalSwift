//
//  NRQuickCheckSwift.swift
//  NRQuickCheckSwiftDemo
//
//  Created by NicoRobine on 2020/6/22.
//  Copyright © 2020 Nicorobine. All rights reserved.
//

import Foundation

protocol Arbitrary {
    static func arbitrary() -> Self
}

protocol Smaller {
    func smaller() -> Self?
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Int: Smaller {
    func smaller() -> Int? {
        return self == 0 ? nil : self/2
    }
}

extension String: Smaller {
    func smaller() -> String? {
        return isEmpty ? nil : String(dropFirst())
    }
}

extension Int {
    static func arbitrary(in range: CountableRange<Int>) -> Int {
        let diff = range.upperBound - range.lowerBound
        return range.lowerBound + (Int.arbitrary() % diff)
    }
}

extension UnicodeScalar: Arbitrary {
    static func arbitrary() -> Unicode.Scalar {
        return UnicodeScalar(Int.arbitrary(in: 65..<90))!
    }
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.arbitrary(in: 0..<40)
        let randomScalars = (0..<randomLength).map { _ in
            UnicodeScalar.arbitrary()
        }
        return String(UnicodeScalarView(randomScalars));
    }
}

extension CGFloat: Arbitrary {
    static func arbitrary() -> CGFloat {
        return CGFloat(drand48())
    }
}

var numberOfIterations = Int.max


func check1<A: Arbitrary>(_ message: String, _ property: (A) -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\"doesn't hold:\(value)")
            return
        }
    }
    print("\"\(message)\"passed\(numberOfIterations)")
}

extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
    }
}

func iterate<A>(while condition:(A) -> Bool, initial: A, next: (A) -> A?) -> A {
    guard let x = next(initial), condition(x) else {
        return initial
    }
    return iterate(while: condition, initial: x, next: next)
}

func check2<A: Arbitrary & Smaller>(_ message: String, _ property: (A) -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            let smallerValue = iterate(while: {!property($0)}, initial: value, next: { $0.smaller() })
            print("\"\(message)\" doesn't hold:\(smallerValue)")
            return
        }
    }
    print("\"\(message)\"passed\(numberOfIterations)tests")
}

func qsort(_ input: [Int]) -> [Int] {
    var array = input
    if array.isEmpty { return [] }
    let pivot = array.removeFirst()
    let lesser = array.filter{ $0 < pivot }
    let greater = array.filter{ $0 >= pivot }
    let intermediate = qsort(lesser) + [pivot]
    return intermediate + qsort(greater)
}

extension Array: Smaller {
    func smaller() -> Array<Element>? {
        guard !isEmpty else {
            return nil
        }
        return Array(dropLast())
    }
}

extension Array: Arbitrary where Element: Arbitrary {
    static func arbitrary() -> [Element] {
        let randomLength = Int.arbitrary(in: 0..<50)
        return (0..<randomLength).map{_ in .arbitrary()}
    }
}

