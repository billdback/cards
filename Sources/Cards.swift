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

/// Standard deck of 52 cards
class Deck {
  var cards = [Card]()

  init() {
    for s in Suit.allValues {
      for r in Rank.allValues {
        let c = Card(rank: r, suit: s)
        cards += [c]
      }
    }
  }

  /// shuffles the deck into random (pseudo-random - whatever) order.
  func sort() {
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
}

/// Just some testing
// TODO replace with better card tests.
// Print all cards in a deck.
let d = Deck()
d.sort()
for c in d.cards {
  print (c.simpleDescription())
}
