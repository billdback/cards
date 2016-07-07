/*
Copyright © 2016 William D. Back
This file is part of cards.
    cards is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    cards is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with cards.  If not, see <http://www.gnu.org/licenses/>.
*/

// copied from https://github.com/apple/swift/blob/5635545f1e2920b66d863bd0832b210b39621d1b/validation-test/stdlib/Dictionary.swift
#if os(OSX) || os(iOS) || os(tvOS) || os(watchOS) 
  import Darwin 
#else 
  import Glibc 
#endif

func uniformRandom(max: Int) -> Int { 
  #if os(Linux) 
    return Int(random() % (max + 1)) 
  #else 
    return Int(arc4random_uniform(UInt32(max))) 
  #endif 
}
// end copy

/// Standard card ranks.  
enum Rank : Int {
  case ace = 1
  case two, three, four, five, six, seven, eight, nine, ten
  case jack, queen, king

  func simpleDescription() -> String {
    switch self {
    case .ace:
      return "A"
    case .jack:
      return "J"
    case .queen:
      return "Q"
    case .king:
      return "K"
    default:
      return String(self.rawValue)
    }
  }

  static let allValues = [ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king]
}

/// Standard card suits.
enum Suit {
  case clubs, diamonds, hearts, spades

  func simpleDescription() -> String {
    switch self {
    case .clubs:
      return "♣️"
    case .diamonds:
      return "♦️"
    case .hearts:
      return "♥️"
    case .spades:
      return "♠️"
    }
  }

  static let allValues = [clubs, diamonds, hearts, spades]
}

/// Standard card suits.
enum rankOfHands {

  case highCard, onePair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush

  func simpleDescription() -> String {
    switch self {
    case .highCard:
      return "high card"
    case .onePair:
      return "one pair"
    case .twoPair:
      return "two pair"
    case .threeOfAKind:
      return "three of a kind"
    case .straight:
      return "straight"
    case .flush:
      return "flush"
    case .fullHouse:
      return "full house"
    case .fourOfAKind:
      return "four of a kind"
    case .straightFlush:
      return "straight flush"
    }
  }

  static let allValues = [highCard, onePair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush]
}

/// Card with a rank and suit.
class Card {
  var rank : Rank;
  var suit : Suit;

  init (rank : Rank, suit : Suit) {
    self.rank = rank
    self.suit = suit
  }

  func simpleDescription () -> String {
    var sd = ""
    if (rank != Rank.ten) { sd += " "} // padding to make the cards line up.
    sd += "\(rank.simpleDescription())\(suit.simpleDescription())"
    return sd
  }
}

protocol DeckProtocol {
  mutating func shuffle()
  mutating func nextCard() -> Card
}

/// Standard deck of 52 cards
class StandardDeck: DeckProtocol {
  /// Cards in the deck.
  var cards = [Card]()
  /// The index for the top card in the deck.
  var topCard = 0

  init() {
    for s in Suit.allValues {
      for r in Rank.allValues {
        let c = Card(rank: r, suit: s)
        cards += [c]
      }
    }
  }

  /// shuffles the deck into random (pseudo-random - whatever) order.
  func shuffle() {
    topCard = 0 // reset
    // just run through 1000 iterations and swap the cards.  There are quicker algorithms that I'll leave to the reader.
    var cnt = 0
    repeat {
      let card1 = uniformRandom(52)
      let card2 = uniformRandom(52)
      let temp = cards[card1]
      cards[card1] = cards[card2]
      cards[card2] = temp

      cnt += 1
    } while cnt < 1000
  }

  /// Returns the next card in the deck
  // TODO add error handling code for going past the end of the deck.
  func nextCard() -> Card {
    topCard += 1
    return cards[self.topCard - 1]
  }

  /// Returns the number of cards remaining in the deck.
  func cardsRemaining() -> Int {
    return cards.count - topCard
  }
}

/// Hand of cards with no specific number of cards.
class Hand {
  /// actual cards in hand
  var cards: [Card] = []
  
  /// returns the number of cards in the hand
  var nbrCards : Int {
    get {
      return cards.count
    }
  }

  func getCard (c : Int) -> Card {
    return cards[c]
  }

  func addCard(c : Card) {
    cards.append(c)
  }

  /// Returns the had as a string.
  func simpleDescription() -> String {
    var results = ""
    var first = true
    for c in cards {
      results += (first ? "" : " ") + c.simpleDescription()
      first = false
    }
    return results
  }

}

// Just some testing
// TODO replace with better card tests.
// Print all cards in a deck.
let d = StandardDeck()
d.shuffle()
print ("shuffeled deck:  ", terminator:"")
for c in d.cards {
  print (c.simpleDescription(),terminator:" ")
}
print ("")

// create some hands and populate, then print.
var h1 : Hand = Hand()
var h2 : Hand = Hand()
for cnt in 1...5 {
  h1.addCard(d.nextCard())
  h2.addCard(d.nextCard())
}
print ("hand 1:  \(h1.simpleDescription())")
print ("hand 2:  \(h2.simpleDescription())")
