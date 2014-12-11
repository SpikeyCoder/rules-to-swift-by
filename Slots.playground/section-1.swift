// 🎰 Slots

import Darwin

final class SlotMachine {
    enum Symbol: String {
        case Cherry = "🍒"
        case Orange = "🍊"
        case Lemon = "🍋"
        case Grapes = "🍇"
        case Watermelon = "🍉"
        case Bell = "🔔"
        case Moneybags = "💰"

        static func random() -> Symbol {
            let symbols: [Symbol] = [.Cherry, .Bell, .Watermelon, .Lemon, .Orange, .Grapes, .Moneybags]
            return symbols[Int(arc4random_uniform(UInt32(symbols.count)))]
        }
    }

    private let schedule: (Symbol, Symbol, Symbol) -> Int

    private(set) var spins: Int = 0

    init() {
        let (🍒, 🍊, 🍋, 🍇, 🍉, 🔔, 💰) = (Symbol.Cherry, Symbol.Orange, Symbol.Lemon, Symbol.Grapes, Symbol.Watermelon, Symbol.Bell, Symbol.Moneybags)

        schedule = { (a, b, c) in
            switch (a, b, c) {
            case (🍒, _, _): return 2
            case (🍒, 🍒, _): return 5
            case (🍒, 🍒, 🍒): return 10
            case (🍊, 🍊, 🍊): return 15
            case (🍋, 🍋, 🍋): return 20
            case (🍇, 🍇, 🍇): return 25
            case (🍉, 🍉, 🍉): return 30
            case (🔔, 🔔, 🔔): return 50
            case (💰, 💰, 💰): return 100
            default:
                return 0
            }
        }
    }

    func spin(#bet: Int) -> (Int, (Symbol, Symbol, Symbol)) {
        spins = spins.successor()

        let reels = (Symbol.random(), Symbol.random(), Symbol.random())
        let payout = bet * schedule(reels)

        return (payout, reels)
    }
}

let slotMachine = SlotMachine()

//class RiggedSlotMachine: SlotMachine {
//    override func spin(#bet: Int) -> (Int, (Symbol, Symbol, Symbol)) {
//        spins = spins.successor()
//
//        var reels = (Symbol.random(), Symbol.random(), Symbol.random())
//        var payout = bet * schedule(reels)
//
//        if spins % 10 == 0 {
//            reels = (Symbol.random(), reels.1, reels.2)
//            payout = bet * schedule(reels)
//        }
//
//        return (bet * payout, reels)
//    }
//}

//
//var cash = 1000
//for _ in 1...1000 {
//    let bet = 1
//    let (payout, reels) = slotMachine.spin(bet: bet)
//    println("\(reels.0.rawValue)\(reels.1.rawValue)\(reels.2.rawValue)")
//
//    cash = cash - bet + payout
//}
//
//println(cash)

