// ♠️♥️♦️♣️ Poker

import Darwin

enum Suit: String {
    case Clubs = "Clubs"
    case Diamonds = "Diamonds"
    case Hearts = "Hearts"
    case Spades = "Spades"

    static var orderedMembers: [Suit] {
        return [.Clubs, .Diamonds, .Hearts, .Spades]
    }

    var shorthand: String {
        switch self {
        case .Clubs: return "♣︎"
        case .Diamonds: return "♦︎"
        case .Hearts: return "♥︎"
        case .Spades: return "♠︎"
        }
    }

    enum Color: String {
        case Black = "Black"
        case Red = "Red"
    }

    var color: Color {
        switch self {
        case .Clubs, .Spades:
            return .Black
        case .Diamonds, .Hearts:
            return .Red
        }
    }
}

extension Suit: Comparable {}

func <(lhs: Suit, rhs: Suit) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

extension Suit: Printable {
    var description: String {
        return rawValue
    }
}

// MARK: -

enum Rank: Int {
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace

    static var orderedMembers: [Rank] {
        return [.Two, .Three, .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten, .Jack, .Queen, .King, .Ace]
    }

    var shorthand: String {
        switch self {
        case .Jack: return "J"
        case .Queen: return "Q"
        case .King: return "K"
        case .Ace: return "A"
        default:
            return "\(rawValue)"
        }
    }
}

extension Rank: Comparable {}

func <(lhs: Rank, rhs: Rank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

extension Rank: Printable {
    var description: String {
        switch self {
        case .Ace: return "Ace"
        case .Two: return "Two"
        case .Three: return "Three"
        case .Four: return "Four"
        case .Five: return "Five"
        case .Six: return "Six"
        case .Seven: return "Seven"
        case .Eight: return "Eight"
        case .Nine: return "Nine"
        case .Ten: return "Ten"
        case .Jack: return "Jack"
        case .Queen: return "Queen"
        case .King: return "King"
        }
    }
}

// MARK: -

struct Card {
    let rank: Rank
    let suit: Suit

    var shorthand: String {
        return "\(suit.shorthand)\(rank.shorthand)"
    }

    var symbol: String {
        switch (rank, suit) {
        case (.Ace, .Spades):	    return "🂡"
            // ...
        case (.King, .Clubs):	    return "🃞"
        default: return ""
        }
    }
}

extension Card: Printable {
    var description: String {
        return shorthand
    }
}

extension Card: Comparable {}

func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.rank == rhs.rank && lhs.suit == rhs.suit
}

func <(lhs: Card, rhs: Card) -> Bool {
    return lhs.rank < rhs.rank || (lhs.rank == rhs.rank && lhs.suit < rhs.suit)
}

// MARK: -

func powerSet<T>(list: [T]) -> [[T]] {
    var subsetCount = 1 << countElements(list)
    var subsets: [[T]] = []
    for i in 0..<subsetCount {
        var subset: [T] = []
        for j in 0..<countElements(list) {
            if (i >> j) & 0x1 > 0 {
                subset.append(list[j])
            }
        }
        subsets.append(subset)
    }

    return subsets
}

func possibleHands(cards: [Card]) -> [[Card]] {
    return powerSet(cards).filter { countElements($0) > 0 && countElements($0) <= 5 }
}

func equalMembers<S: SequenceType where S.Generator.Element: Equatable>(sequence: S) -> Bool {
    var generator = sequence.generate()
    if let head = generator.next() {
        while var next = generator.next() {
            if head != next {
                return false
            }
        }
    }

    return true
}

typealias 🂠 = Card

enum PokerHand {
    case StraightFlush(🂠, 🂠, 🂠, 🂠, 🂠)
    case FourOfAKind(🂠, 🂠, 🂠, 🂠)
    case FullHouse((🂠, 🂠, 🂠), (🂠, 🂠))
    case Flush(🂠, 🂠, 🂠, 🂠, 🂠)
    case Straight(🂠, 🂠, 🂠, 🂠, 🂠)
    case ThreeOfAKind(🂠, 🂠, 🂠)
    case TwoPair((🂠, 🂠), (🂠, 🂠))
    case Pair(🂠, 🂠)
    case HighCard(🂠)

    var cards: [Card] {
        switch self {
        case let .HighCard(c1): return [c1]
        case let .Pair(c1, c2): return [c1, c2]
        case let .TwoPair((c1, c2), (c3, c4)): return [c1, c2, c3, c4]
        case let .ThreeOfAKind(c1, c2, c3): return [c1, c2, c3]
        case let .Straight(c1, c2, c3, c4, c5): return [c1, c2, c3, c4, c5]
        case let .Flush(c1, c2, c3, c4, c5): return [c1, c2, c3, c4, c5]
        case let .FullHouse((c1, c2, c3), (c4, c5)): return [c1, c2, c3, c4, c5]
        case let .FourOfAKind(c1, c2, c3, c4): return [c1, c2, c3, c4]
        case let .StraightFlush(c1, c2, c3, c4, c5): return [c1, c2, c3, c4, c5]
        }
    }

    var name: String {
        switch self {
        case let .HighCard: return "High Card"
        case let .Pair: return "Pair"
        case let .TwoPair: return "Two Pair"
        case let .ThreeOfAKind: return "Three of a Kind"
        case let .Straight: return "Straight"
        case let .Flush: return "Flush"
        case let .FullHouse: return "Full House"
        case let .FourOfAKind: return "Four of a Kind"
        case let .StraightFlush: return "Straight Flush"
        }
    }

    internal init?(straightFlush cards: [Card]) {
        if cards.count == 5 && PokerHand(straight: cards) != nil && PokerHand(flush: cards) != nil {
            self = .StraightFlush(cards[0], cards[1], cards[2], cards[3], cards[4])
        } else {
            return nil
        }
    }

    internal init?(fourOfAKind cards: [Card]) {
        if cards.count == 4 && equalMembers(map(cards){$0.rank}) {
            self = .FourOfAKind(cards[0], cards[1], cards[2], cards[3])
        } else {
            return nil
        }
    }

    init?(fullHouse cards: [Card]) {
        return nil
    }

    init?(flush cards: [Card]) {
        if cards.count == 5 && equalMembers(map(cards) {$0.suit}) {
            self = .Flush(cards[0], cards[1], cards[2], cards[3], cards[4])
        } else {
            return nil
        }
    }

    init?(straight cards: [Card]) {
        if cards.count != 5 {
            return nil
        }

        let ranks = sorted(cards.map({$0.rank}))
        if ranks.last!.rawValue - ranks.first!.rawValue < 4 {
            return nil
        }

        for (rank, rawValue) in Zip2(ranks, stride(from: ranks.first!.rawValue, to: ranks.last!.rawValue, by: 1)) {
            if rank.rawValue != rawValue {
                return nil
            }
        }

        self = .Straight(cards[0], cards[1], cards[2], cards[3], cards[4])
    }

    init?(threeOfAKind cards: [Card]) {
        if cards.count == 3 && equalMembers(map(cards) {$0.rank}) {
            self = .ThreeOfAKind(cards[0], cards[1], cards[2])
        } else {
            return nil
        }
    }

    init?(twoPair cards: [Card]) {
        return nil // TODO: -
    }

    init?(pair cards: [Card]) {
        if cards.count == 2 && equalMembers(map(cards) {$0.rank}) {
            self = .Pair(cards[0], cards[1])
        } else {
            return nil
        }
    }

    init?(highCard cards: [Card]) {
        if cards.count == 1 {
            self = .HighCard(cards[0])
        } else {
            return nil
        }
    }

    init?(_ cards: [Card]) {
        var hands: [PokerHand] = []
        for hand in possibleHands(cards) {
            if let pokerHand = PokerHand(straightFlush: hand) ??
                PokerHand(flush: hand) ??
                PokerHand(straight: hand) ??
                PokerHand(threeOfAKind: hand) ??
                PokerHand(twoPair: hand) ??
                PokerHand(pair: hand) ??
                PokerHand(highCard: hand)
            {
                hands.append(pokerHand)
            }
        }

        self = maxElement(hands)
    }
}


extension PokerHand: Equatable {}

func ==(lhs: PokerHand, rhs: PokerHand) -> Bool {
    switch (lhs, rhs) {
    case (.HighCard, .HighCard): fallthrough
    case (.Pair, .Pair): fallthrough
    case (.TwoPair, .TwoPair): fallthrough
    case (.ThreeOfAKind, .ThreeOfAKind): fallthrough
    case (.Straight, .Straight): fallthrough
    case (.Flush, .Flush): fallthrough
    case (.FullHouse, .FullHouse): fallthrough
    case (.FourOfAKind, .FourOfAKind): fallthrough
    case (.StraightFlush, .StraightFlush):
        return sorted(lhs.cards) == sorted(rhs.cards)
    default:
        return false
    }
}

extension PokerHand: Comparable {}

func <(lhs: PokerHand, rhs: PokerHand) -> Bool {
    switch (lhs, rhs) {
    case (.HighCard, .HighCard): fallthrough
    case (.Pair, .Pair): fallthrough
    case (.TwoPair, .TwoPair): fallthrough
    case (.ThreeOfAKind, .ThreeOfAKind): fallthrough
    case (.Straight, .Straight): fallthrough
    case (.Flush, .Flush): fallthrough
    case (.FullHouse, .FullHouse): fallthrough
    case (.FourOfAKind, .FourOfAKind): fallthrough
    case (.StraightFlush, .StraightFlush):
        return maxElement(lhs.cards) < maxElement(rhs.cards)
    case (_, .HighCard): fallthrough
    case (.TwoPair, .Pair), (.TwoPair, .HighCard): fallthrough
    case (.ThreeOfAKind, .TwoPair), (.ThreeOfAKind, .Pair), (.ThreeOfAKind, .HighCard): fallthrough
    case (.Straight, .ThreeOfAKind), (.Straight, .TwoPair), (.Straight, .Pair), (.Straight, .HighCard): fallthrough
    case (.Flush, .Straight), (.Flush, .ThreeOfAKind), (.Flush, .TwoPair), (.Flush, .Pair), (.Flush, .HighCard): fallthrough
    case (.FullHouse, .Flush), (.FullHouse, .Straight), (.FullHouse, .ThreeOfAKind), (.FullHouse, .TwoPair), (.FullHouse, .Pair), (.FullHouse, .HighCard): fallthrough
    case (.FourOfAKind, .FullHouse), (.FourOfAKind, .Flush), (.FourOfAKind, .Straight), (.FourOfAKind, .ThreeOfAKind), (.FourOfAKind, .TwoPair), (.FourOfAKind, .Pair), (.FourOfAKind, .HighCard): fallthrough
    case (.StraightFlush, _):
        return false
    default:
        return true
    }
}

extension PokerHand: Printable {
    var description: String {
        let list = join(", ", map(cards){$0.description})
        return "\(name) - \(list)"
    }
}

