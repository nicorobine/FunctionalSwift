//
//  main.swift
//  NREnumDemo
//
//  Created by NicoRobine on 2020/6/28.
//  Copyright © 2020 Nicorobine. All rights reserved.
//

import Foundation

// MARK: - 基本枚举

enum Movement {
    case Left
    case Right
    case Up
    case Down
}

enum MovementInt: Int {
    case Left = 6
    case Right
    case Up
    case Down
}

enum MovementString: String {
    case Left
    case Right
    case Up
    case Down
}

enum MovementDouble: Double {
    case Left
    case Right
    case Up
    case Down
}

enum VNodeFlags : UInt32 {
    case Delete =   0x00000001
    case Write =    0x00000002
    case Extended = 0x00000004
    case Attrib =   0x0000008
    case Link =     0x00000010
}

func movementTest() {
    let aMovement = Movement.Left
    let bMovement = MovementInt.Right
    let cMovement = MovementDouble.Up
    let dMovement = MovementInt(rawValue: 9)
    

    switch aMovement {
        case.Left:
            print("left")
        default:()
    }
    
    if case Movement.Left = aMovement {
        print("Left");
    }
    
    if aMovement == .Left {
        print("Left");
    }
    
    if case MovementInt.Right = bMovement {
        print("bMovement raw value: \(bMovement.rawValue)")
    }
    
    if case MovementDouble.Up = cMovement {
        print("cMovement raw value: \(cMovement.rawValue)")
    }
    
    if let m = dMovement {
        if case MovementInt.Down = m {
            print("dMovement raw value: \(m.rawValue)")
        }
    }
}

// MARK: - 嵌套枚举

enum Character {
    
    enum Weapon {
        case Bow
        case Sword
        case Lance
        case Dagger
    }
    
    enum Helmet {
        case Wooden
        case Iron
        case Diamond
    }
    case Thief
    case Warrior
    case Knight
}

// MARK: - 包含枚举

struct TestContainer {
    enum CharacterType {
        case Thief
        case Warrior
        case Knight
    }
    enum Weapon {
        case Bow
        case Sword
        case Lance
        case Dagger
    }
    
    let type: CharacterType
    let weapon: Weapon
}

// MARK: - 关联值

enum Trade {
    case Buy(stock: String, amount: Int)
    case Sell(stock: String, amount: Int)
}

func trade(type: Trade) {
    switch type {
    case .Buy(stock: "a", amount: _):
        print("stock : \(type)")
    case .Buy(stock: "b", amount: _):
        print("stock : \(type)")
    default:
        print("default")
    }
}

func testTrade() {
    let t = Trade.Buy(stock: "a", amount: 3)
    
    if case let Trade.Buy(stock, amount) = t {
        print("stock: \(stock) amount: \(amount)")
    }
    
    trade(type: t)
}

// MARK: - 元组

typealias Config = (RAM: Int, CPU: String, GPU: String)

func selectRAM(_ config: Config) -> Config {
    return (RAM: 32, CPU: config.CPU, GPU: config.GPU);
}

func selectCPU(_ config: Config) -> Config {
    return (RAM: config.RAM, CPU: "3.2GHZ", GPU: config.GPU)
}

func selectGPU(_ config: Config) -> Config {
    return (RAM: config.RAM, CPU: config.CPU, GPU: "NVidia")
}

enum Desktop {
    case Cube(Config)
    case Tower(Config)
    case Rack(Config)
}

// MARK: 自定义运算符
infix operator <^>: ATPrecedence
precedencegroup ATPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

func <^>(lhs: Config, rhs: (Config) -> Config) -> Config {
    return rhs(lhs);
}

func testDesktop() {
    let aTower = Desktop.Tower(selectCPU(selectGPU(selectRAM((0, "", "") as Config))))
    print("aTower: \(aTower)")
    
    let config = (0, "", "") <^> selectRAM(_:) <^> selectCPU(_:) <^> selectGPU(_:);
    let aCube = Desktop.Cube(config);
    print("aCube: \(aCube)")
}

// 拥有不同值的用例
enum UserAction {
    case OpenURL(url: URL)
    case SwitchProcess(processId: uint32)
    case Restart(time: NSDate?, intoCommandLine: Bool)
}

// 实现编辑器的选择
enum Selection {
    case None
    case Single(Range<Int>)
    case Multiple([Range<Int>])
}

// 映射不同的标识码
enum BarCode {
    case UPCA(numberSystem: Int, mamufacturer: Int, product: Int, check: Int)
    case QRCode(productCode: String)
}

// 又或者假设你在封装一个 C 语言库，正如 Kqeue BSD/Darwin 通知系统:
// https://www.freebsd.org/cgi/man.cgi?query=kqueue&sektion=2
enum KqueueEvent {
    case UserEvent(identifier: UInt, fflags: [UInt32], data: Int)
    case ReadFD(fd: UInt, data: Int)
    case WriteFD(fd: UInt, data: Int)
    case VnodeFD(fd: UInt, fflags: [UInt32], data: Int)
    case ErrorEvent(code: UInt, message: String)
}

// MARK - 方法和属性(只能是计算属性)

enum Wearable {
    enum Weight: Int {
        case Light = 1
    }
    
    enum Armor: Int {
        case Light = 2
    }
    
    case Helmet(weight: Weight, armor: Armor)
    
    func attributes() -> (weight: Int, armor: Int) {
        switch self {
        case .Helmet(let w, armor: let a):
            return (weight: w.rawValue * 2, a.rawValue * 4);
        }
    }
}

enum Device {
    case iPad, iPhone, AppleTV, AppleWatch
    
    func introduced() -> String {
        switch self {
        case .AppleTV:
            return "\(self) was introduced 2006"
        case .iPhone:
            return "\(self) was introduced 2007"
        case .iPad:
            return "\(self) was introduced 2010"
        case .AppleWatch:
            return "\(self) was introduced 2014"
        }
    }
    
    var year: Int {
        switch self {
        case .AppleTV:
            return 2006
        case .iPhone:
            return 2007
        case .iPad:
            return 2010
        case .AppleWatch:
            return 2014
        }
    }
    
    static func fromName(name: String) -> Device? {
        switch name {
        case "iPad":
            return .iPad
        case "iPhone":
            return .iPhone
        case "AppleTV":
            return .AppleTV
        case "AppleWatch":
            return .AppleWatch
        default:
            return nil
        }
    }
    
    // ⚠️报错会把AppleTV当作属性
//    static func sizeType() -> String {
//        switch self {
//        case Device.AppleTV:
//            return "big"
//        case Device.iPhone:
//            return "normal"
//        case Device.iPad:
//            return "large"
//        case Device.AppleWatch:
//            return "small"
//        }
//    }
}

enum TriStateSwitch {
    case Off, Low, Hight
    
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .Hight
        case .Hight:
            self = .Off
        }
    }
}

// MARK: - 枚举进阶

// MARK: - 协议和扩展


print("Hello, World!")
movementTest()
testTrade()
testDesktop()

