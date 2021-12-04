import std/[parseutils, strscans]
type
  CallRange = 0..99
  Card = object
    vals: set[CallRange]
    data: array[25, (int, bool)]
iterator parseInts(line: string): int =
  var i = 0
  while i < line.len:
    var val: int
    let offset = line.parseInt(val, i)
    if offset > 0:
      yield val
    i += offset + 1

proc getNums(line: string): (bool, (int, int, int, int, int)) =
  template res(i: static int): untyped =
    result[1][i]
  result[0] = line.scanf("$s$i$s$i$s$i$s$i$s$i", res 0, res 1, res 2, res 3, res 4)

proc parseData(path: string): (seq[int], seq[Card]) =
  var
    cardLine = 0
    card: Card

  for line in path.lines:
    if result[0].len == 0:
      for val in parseInts(line):
        result[0].add val
    elif line.len == 0:
      if cardLine > 0:
        result[1].add card
        card = default(Card)
      cardLine = 0
    else:
      let
        (gotVal, data) = line.getNums
        (a, b, c, d, e) = data
      if gotVal:
        card.vals.incl {CallRange a, b, c, d, e}
        card.data[cardLine * 5] = (a, false)
        card.data[cardLine * 5 + 1] = (b, false)
        card.data[cardLine * 5 + 2] = (c, false)
        card.data[cardLine * 5 + 3] = (d, false)
        card.data[cardLine * 5 + 4] = (e, false)
        inc cardLine
  if cardLine == 5:
    result[1].add card

proc didWin(card: Card): bool =
  for x in 0..<5:
    if card.data[x][1]:
      block ySolve:
        for y in 1..<5:
          if not card.data[y * 5 + x][1]:
            break ySolve
        return true

  for y in 0..<5:
    if card.data[y * 5][1]:
      block xSolve:
        for x in 1..<5:
          if not card.data[y * 5 + x][1]:
            break xSolve
        return true

proc calcScore(c: Card): int =
  for x in c.data:
    if not x[1]:
      result += x[0]


proc playGame(draws: seq[int], cards: var seq[Card],
    earlyWin: static bool): int =
  when not earlyWin:
    type CardRange = 0..1000
    var won: set[CardRange]
  for draw in draws:
    var cardInd = 0
    for card in cards.mitems:
      if draw in card.vals:
        for slot in card.data.mitems:
          if slot[0] == draw:
            slot[1] = true
            if card.didWin:
              when earlyWin:
                return calcScore(card) * draw
              else:
                won.incl CardRange(cardInd)
                if won.len == cards.len:
                  return calcScore(card) * draw
      inc cardInd


block:
  var (moves, cards) = parseData("test.txt")
  echo playGame(moves, cards, true)
  echo playGame(moves, cards, false)

block:
  var (moves, cards) = parseData("input.txt")
  echo playGame(moves, cards, true)
  echo playGame(moves, cards, false)
