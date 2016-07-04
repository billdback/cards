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
}

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
}

class Card {
  var rank : Rank;
  var suit : Suit;

  init (rank : Rank, suit : Suit) {
    self.rank = rank
    self.suit = suit
  }

  func simpleDescription () -> String {
    return "\(rank)\(suit)"
  }
}

