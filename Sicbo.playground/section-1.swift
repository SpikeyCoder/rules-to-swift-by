// 🎲🎲🎲 Sicbo

import Darwin

func rollD6() -> Int {
    return Int(arc4random_uniform(6)) + 1
}

enum D6: Int {
    case One = 1, Two, Three, Four, Five, Six
}

extension D6: Printable {
    var description: String {
        switch self {
        case .One: return "⚀"
        case .Two: return "⚁"
        case .Three: return "⚂"
        case .Four: return "⚃"
        case .Five: return "⚄"
        case .Six: return "⚅"
        }
    }
}

extension D6: IntegerLiteralConvertible {
    init(integerLiteral value: Int) {
        self = D6(rawValue: value)!
    }
}

// MARK: -

enum SicBoBet {
    case Small
    case Big
    case AnyTriple
    case SpecificTriple(D6)
    case SpecificDouble(D6)
    case SingleNumber(D6)
    case Combination(D6, D6)
    case Total(D6.RawValue)

    func payout(roll: (D6, D6, D6)) -> Int {
        let (一, 二, 三) = roll
        let total = roll.0.rawValue + roll.1.rawValue + roll.2.rawValue

        switch self {
        case .Small where 4...10 ~= total: return 1
        case .Big where 11...17 ~= total: return 1
        case .AnyTriple where 一 == 二 && 二 == 三: return 30
        case .SpecificTriple(let n) where n == 一 && 一 == 二 && 二 == 三: return 180
        case .SpecificDouble(let n):
            switch roll {
            case (n, n, _), (n, _, n), (_, n, n): return 11 
            default:
                return 0
            }
        case .Combination(let a, let b):
            switch roll {
            case (a, b, _), (b, a, _), (a, _, b), (b, _, a), (_, a, b), (_, b, a): return 6
            default:
                return 0
            }
        case .SingleNumber(let n):
            switch roll {
            case (n, n, n): return 3
            case (n, n, _), (n, _, n), (_, n, n): return 2
            case (n, _, _), (_, n, _), (_, _, n): return 1
            default:
                return 0
            }
        case .Total(total):
            switch total {
            case 4, 17: return 50
            case 5, 16: return 18
            case 6, 15: return 14
            case 7, 14: return 12
            case 8, 13: return 8
            case 9, 10, 11, 12: return 6
            default:
                return 0
            }
        default:
            return 0
        }
    }
}

extension SicBoBet: Printable {
    var description: String {
        switch self {
        case .Small: return "Small (小)"
        case .Big: return "Big (大)"
        case .AnyTriple: return "Any Triple"
        case .SpecificTriple(let n): return "Triple \(n)"
        case .SpecificDouble(let n): return "Double \(n)"
        case .SingleNumber(let n): return "Single \(n)"
        case .Combination(let a, let b): return "Combaintion \(a)\(b)"
        case .Total(let total): return "Total \(total)"
        }
    }
}

//func roll() -> D6 {
//    return D6(rawValue: Int(arc4random_uniform(6)) + 1)!
//}
//
//func roll3() -> (D6, D6, D6) {
//    return (roll(), roll(), roll())
//}
//
//let bet = SicBoBet.Big
//let wager = 100
//let payout = wager * bet.payout(roll3())

