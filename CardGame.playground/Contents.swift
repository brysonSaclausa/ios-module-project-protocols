import Foundation

//: ## Step 1
//: Create an enumeration for the value of a playing card. The values are: `ace`, `two`, `three`, `four`, `five`, `six`, `seven`, `eight`, `nine`, `ten`, `jack`, `queen`, and `king`. Set the raw type of the enum to `Int` and assign the ace a value of `1`.
enum CardValue: Int {
    case ace = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
}




//: ## Step 2
//: Once you've defined the enum as described above, take a look at this built-in protocol, [CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible) and make the enum conform to that protocol. Make the face cards return a string of their name, and for the numbered cards, simply have it return that number as a string.
extension CardValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .ace: return "One"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        case .six: return "Six"
        case .seven: return "Seven"
        case .eight: return "Eight"
        case .nine: return "Nine"
        case .ten: return "Ten"
        case .jack: return "Jack"
        case .queen: return "Queen"
        case .king: return "King"
        }
    }
    static var allRanks: [CardValue] {
        return [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
       
    }
    
}



//: ## Step 3
//: Create an enum for the suit of a playing card. The values are `hearts`, `diamonds`, `spades`, and `clubs`. Use a raw type of `String` for this enum (this will allow us to get a string version of the enum cases for free, no use of `CustomStringConvertible` required).
enum Suit: String {
    case hearts
    case diamonds
    case spades
    case clubs
    
    static var cardSuits: [Suit] {
        return [.hearts, .diamonds, .spades, .clubs]
        
    }
    
}



//: ## Step 4
//: Using the two enums above, create a `struct` called `Card` to model a single playing card. It should have constant properties for each constituent piece (one for suit and one for rank).
struct Card {
    
    var cardValue: CardValue
    var cardSuit: Suit
    
    
}



//: ## Step 5
//: Make the card also conform to `CustomStringConvertible`. When turned into a string, a card's value should look something like this, "ace of spades", or "3 of diamonds".
extension Card: CustomStringConvertible {
    var description: String {
        return "\(cardValue) of \(cardSuit)"
        
    }
}


//: ## Step 6
//: Create a `struct` to model a deck of cards. It should be called `Deck` and have an array of `Card` objects as a constant property. A custom `init` function should be created that initializes the array with a card of each rank and suit. You'll want to iterate over all ranks, and then over all suits (this is an example of _nested `for` loops_). See the next 2 steps before you continue with the nested loops.
struct DeckOfCards {
    var cardArray = [Card] ()
    init() {
        for rank in CardValue.allRanks {
            for suit in Suit.cardSuits {
                switch suit {
                case .hearts: cardArray.append(Card(cardValue: rank, cardSuit: suit))
                case .spades: cardArray.append(Card(cardValue: rank, cardSuit: suit))
                case .clubs: cardArray.append(Card(cardValue: rank, cardSuit: suit))
                case .diamonds: cardArray.append(Card(cardValue: rank, cardSuit: suit))
                }
            }
        }
    }
    func drawCard() -> Card {
        if let randomCard = cardArray.randomElement() {
            return randomCard
        }
        return Card.init(cardValue: .ace, cardSuit: .clubs)
        
    }
}

let newDeck = DeckOfCards.init()
print(newDeck.drawCard())
print(newDeck.cardArray)


//: ## Step 7
//: In the rank enum, add a static computed property that returns all the ranks in an array. Name this property `allRanks`. This is needed because you can't iterate over all cases from an enum automatically.




//: ## Step 8
//: In the suit enum, add a static computed property that returns all the suits in an array. Name this property `allSuits`.




//: ## Step 9
//: Back to the `Deck` and the nested loops. Now that you have a way to get arrays of all rank values and all suit values, create 2 `for` loops in the `init` method, one nested inside the other, where you iterate over each value of rank, and then iterate over each value of suit. See an example below to get an idea of how this will work. Imagine an enum that contains the 4 cardinal directions, and imagine that enum has a property `allDirections` that returns an array of them.
//: ```
//: for direction in Compass.allDirections {
//:
//:}
//:```



//: ## Step 10
//: These loops will allow you to match up every rank with every suit. Make a `Card` object from all these pairings and append each card to the `cards` property of the deck. At the end of the `init` method, the `cards` array should contain a full deck of standard playing card objects.





//: ## Step 11
//: Add a method to the deck called `drawCard()`. It takes no arguments and it returns a `Card` object. Have it draw a random card from the deck of cards and return it.
//: - Callout(Hint): There should be `52` cards in the deck. So what if you created a random number within those bounds and then retrieved that card from the deck? Remember that arrays are indexed from `0` and take that into account with your random number picking.





//: ## Step 12
//: Create a protocol for a `CardGame`. It should have two requirements:
//: * a gettable `deck` property
//: * a `play()` method
protocol CardGame {
    var deck: DeckOfCards { get }
    func play()
    
}



//: ## Step 13
//: Create a protocol for tracking a card game as a delegate called `CardGameDelegate`. It should have two functional requirements:
//: * a function called `gameDidStart` that takes a `CardGame` as an argument
//: * a function with the following signature: `game(player1DidDraw card1: Card, player2DidDraw card2: Card)`
protocol CardGameDelegate {
    func gameDidStart(_ game: CardGame)                             //delegate - a representation of a specific class
    func game(player1DidDraw card1: Card, player2DidDraw card2: Card)
    
    
    
}



//: ## Step 14
//: Create a class called `HighLow` that conforms to the `CardGame` protocol. It should have an initialized `Deck` as a property, as well as an optional delegate property of type `CardGameDelegate`.
class HighLow: CardGame {
    var deck: DeckOfCards
    
    var getDeck: DeckOfCards
    var delegate: CardGameDelegate
    func play() {
        let card1 = getDeck.drawCard()
        let card2 = getDeck.drawCard()
        
        if card1 == card2 {
            print("Round ends in a tie with \(card1.cardValue) of \(card2.cardSuit)")
        }
        else if card1 < card2 {
            print("Player 2 wins with \(card2.cardValue) of \(card2.cardSuit)")
        }
        else if card2 < card1 {
            print("Player 1 wins with \(card1.cardValue) of \(card1.cardSuit)")
        }
    }
    
    init(getDeck: DeckOfCards, delegate: CardGameDelegate) {
        self.getDeck = getDeck
        self.delegate = delegate
    }
    
}



//: ## Step 15
//: As part of the protocol conformance, implement a method called `play()`. The method should draw 2 cards from the deck, one for player 1 and one for player 2. These cards will then be compared to see which one is higher. The winning player will be printed along with a description of the winning card. Work will need to be done to the `Suit` and `Rank` types above, so see the next couple steps before continuing with this step.




//: ## Step 16
//: Take a look at the Swift docs for the [Comparable](https://developer.apple.com/documentation/swift/comparable) protocol. In particular, look at the two functions called `<` and `==`.




//: ## Step 17
//: Make the `Rank` type conform to the `Comparable` protocol. Implement the `<` and `==` functions such that they compare the `rawValue` of the `lhs` and `rhs` arguments passed in. This will allow us to compare two rank values with each other and determine whether they are equal, or if not, which one is larger.
extension CardValue: Comparable {
    static func < (lhs: CardValue, rhs: CardValue) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: CardValue, rhs: CardValue) -> Bool {
}




//: Step 18
//: Make the `Card` type conform to the `Comparable` protocol. Implement the `<` and `==` methods such that they compare the ranks of the `lhs` and `rhs` arguments passed in. For the `==` method, compare **both** the rank and the suit.
    extension Card: Comparable {
        static func < (lhs: Card, rhs: Card) -> Bool {
            return lhs.cardValue < rhs.cardValue
        }
        static func == (lhs:Card, rhs:Card) -> Bool {
            return lhs.cardValue == rhs.cardValue
        }
}



}
//: ## Step 19
//: Back to the `play()` method. With the above types now conforming to `Comparable`, you can write logic to compare the drawn cards and print out 1 of 3 possible message types:
//: * Ends in a tie, something like, "Round ends in a tie with 3 of clubs."
//: * Player 1 wins with a higher card, e.g. "Player 1 wins with 8 of hearts."
//: * Player 2 wins with a higher card, e.g. "Player 2 wins with king of diamonds."
let newTracker = CardGameTracker()
let newDecks = DeckOfCards()
let game1 = HighLow(getDeck: newDecks, delegate: newTracker)


//: ## Step 20
//: Create a class called `CardGameTracker` that conforms to the `CardGameDelegate` protocol. Implement the two required functions: `gameDidStart` and `game(player1DidDraw:player2DidDraw)`. Model `gameDidStart` after the same method in the guided project from today. As for the other method, have it print a message like the following:
//: * "Player 1 drew a 6 of hearts, player 2 drew a jack of spades."
    class CardGameTracker: CardGameDelegate {
        func gameDidStart(_ game: CardGame) {
        }
        
        func game(player1DidDraw card1: Card, player2DidDraw card2: Card) {
        }
        
        
        
            
        }




//: Step 21
//: Time to test all the types you've created. Create an instance of the `HighLow` class. Set the `delegate` property of that object to an instance of `CardGameTracker`. Lastly, call the `play()` method on the game object. It should print out to the console something that looks similar to the following:
//:
//: ```
//: Started a new game of High Low
//: Player 1 drew a 2 of diamonds, player 2 drew a ace of diamonds.
//: Player 1 wins with 2 of diamonds.
//: ```


game1.play()
