// 🂠 Playing Card w/Generics

protocol RankType: Comparable {}
protocol SuitType: Comparable {}

struct Card<R: RankType, S: SuitType> {
    let rank: R
    let suit: S
}

// MARK: -

enum GermanRank: Int, RankType {
    case Sieben = 7, Acht, Neun, Zehn, Unter, Ober, König, Ass
}

func <(lhs: GermanRank, rhs: GermanRank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

enum GermanSuit: String, SuitType {
    case Eichel = "Eichel"
    case Blatt = "Blatt"
    case Herz = "Herz"
    case Schelle = "Schelle"
}

func <(lhs: GermanSuit, rhs: GermanSuit) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

// MARK: -

enum FrenchSuit: String, SuitType {
    case Trèfles = "Trèfles"
    case Carreaux = "Carreaux"
    case Cœurs = "Cœurs"
    case Piques  = "Piques"
}

func <(lhs: FrenchSuit, rhs: FrenchSuit) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

enum FrenchRank: Int, RankType {
    case Deux = 2, Trois, Quatre, Cinq, Six, Sept, Huit, Neuf, Dix, Valet, Dame, Roi, As
}

func <(lhs: FrenchRank, rhs: FrenchRank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

// MARK: -

//typealias GermanCard = Card<GermanRank, GermanSuit>
//
//let siebenDerHerzen = Card<GermanRank, GermanSuit>(rank: .Sieben, suit: .Herz)
//
//
//typealias FrenchCard = Card<FrenchRank, FrenchSuit>
//
//let septDeCœur = FrenchCard(rank: .Sept, suit: .Cœurs)

//siebenDerHerzen == septDeCœur


// MARK: -

class AbstractCard {
    var rank: Any?
    var suit: Any?

    init() {}
}

class GermanCard: AbstractCard {
    init(rank: GermanRank, suit: GermanSuit) {
        super.init()
        self.rank = rank
        self.suit = suit
    }
}

class AbstractDeck {
    var cards: [AbstractCard]?

    private init() {}
}

class GermanDeck: AbstractDeck {
    init(cards: [GermanCard]) {
        super.init()
        self.cards = cards
    }
}

/*
protocol CardType: Comparable {}

struct Deck<C: CardType> {
    let cards: [C]
}

extension Card: CardType {}

func ==<R: RankType, S: SuitType>(lhs: Card<R, S>, rhs: Card<R, S>) -> Bool {
    return lhs.rank == rhs.rank && lhs.rank == rhs.rank
}

func <<R: RankType, S: SuitType>(lhs: Card<R, S>, rhs: Card<R, S>) -> Bool {
    return lhs.rank < rhs.rank || (lhs.rank == rhs.rank && lhs.suit < rhs.suit)
}



let germanDeck = Deck(cards: [siebenDerHerzen])
let frenchDeck = Deck(cards: [septDeCœur])
//let mixedDeck = Deck(cards: [siebenDerHerzen, septDeCœur])
*/
