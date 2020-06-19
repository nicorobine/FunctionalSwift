//
//  BattlesShip.swift
//  NRSwiftFunctionalDemo
//
//  Created by NicoRobine on 2020/6/9.
//  Copyright © 2020 NicoRobine. All rights reserved.
//

import Foundation

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func within(range: Distance) -> Bool {
        return sqrt(x*x + y*y) <= range;
    }
}

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x*x + y*y)
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx*dx + dy*dy)
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx*friendlyDx + friendlyDy*friendlyDy)
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange;
    }
}

extension Ship {
    func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
}

extension Ship {
    func canSafelyEngage3(ship target: Ship, friendly: Ship) -> Bool {
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.position);
    }
}

// MARK: - 一等函数

typealias Region = (Position) -> Bool

// 在半径区域的区域
func circle(radius: Distance) -> Region {
    return { point in point.length <= radius}
}

func circle2(radius: Distance, center: Position) -> Region {
    return { point in point.minus(center).length < radius }
}

func shift(_ region:@escaping Region, by offset: Position) -> Region {
    return { point in region(point.minus(offset))}
}

func invert(_ region:@escaping Region) -> Region {
    return { point in !region(point) }
}

func intersact(_ region:@escaping Region, with other:@escaping Region) -> Region {
    return { point in region(point) && other(point) }
}

func union(_ region:@escaping Region, with other:@escaping Region) -> Region {
    return { point in region(point) || other(point) }
}

func subtract(_ region:@escaping Region, from original:@escaping Region) -> Region {
    return intersact(original, with: invert(region))
}

// MARK: - 扩展成类

struct RegionS {
    let lookup: (Position) -> Bool
}

extension RegionS {
    func shift(by offset: Position) -> RegionS {
        return RegionS(lookup: { point in self.lookup(point.minus(offset)) })
    }
    
    func invert() -> RegionS {
        return RegionS(lookup: { point in !self.lookup(point) })
    }
    
    func intersact(with other: RegionS) -> RegionS {
        return RegionS(lookup: { point in self.lookup(point) && other.lookup(point) })
    }
    
    func union(with other: RegionS) -> RegionS {
        return RegionS(lookup: { point in self.lookup(point) || other.lookup(point) })
    }
    
    func subtract(from original: RegionS) -> RegionS {
        return RegionS(lookup: { point in !self.lookup(point) && original.lookup(point) })
    }
}
