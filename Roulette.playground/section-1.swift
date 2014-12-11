// ⚪️ Roulette

import Darwin

enum RouletteNumber {
    case Zero
    case Number(Int)

    static var interval: ClosedInterval<Int> {
        return 1...36
    }

    var odd: Bool {
        switch self {
        case .Number(let n) where RouletteNumber.interval ~= n:
            return n % 2 == 1
        default:
            return false
        }

    }

    var even: Bool {
        switch self {
        case .Number(let n) where RouletteNumber.interval ~= n:
            return n % 2 == 0
        default:
            return false
        }
    }

    enum Color {
        case Black, Red
    }

    var color: Color? {
        switch self {
        case .Number(1...10), .Number(19...28):
            return odd ? .Red : .Black
        case .Number(11...18), .Number(29...36):
            return odd ? .Black : .Red
        default:
            return nil
        }
    }
}

extension RouletteNumber: Equatable {}

func ==(lhs: RouletteNumber, rhs: RouletteNumber) -> Bool{
    switch (lhs, rhs) {
    case (.Zero, .Zero): return true
    case let (.Number(lhsn), .Number(rhsn)): return lhsn == rhsn
    default:
        return false
    }
}

extension RouletteNumber: IntegerLiteralConvertible {
    init(integerLiteral value: Int) {
        precondition(RouletteNumber.interval ~= value)
        switch value {
        case 0:
            self = .Zero
        default:
            self = .Number(value)
        }
    }
}

enum RouletteBet {
    case Straight(RouletteNumber)
    case Red, Black
    case Odd, Even

    var condition: (RouletteNumber) -> (Bool) {
        switch self {
        case .Straight(let number):
            return {
                switch ($0, number) {
                case (.Zero, .Zero): return true
                case let (.Number(a), .Number(b)): return a == b
                default: return false
                }
            }
        case .Red:
            return { return $0.color != nil && $0.color == .Red }
        case .Black:
            return { return $0.color != nil && $0.color == .Black }
        case .Even:
            return { return $0.even }
        case .Odd:
            return { return $0.odd }
        }
    }
}


let numbers: [RouletteNumber] = [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27,
    13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1,
    20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26]

let bet: RouletteBet = .Red

var hits = 0
for number in numbers {
    if bet.condition(number) {
        hits++
    }
}


let odds = Double(hits) / Double(numbers.count)
