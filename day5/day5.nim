import std/[strscans, intsets, math]

proc addPoint(x, y: int, arr: var array[1000 * 1000, int], val: var int) =
  let index = 1000 * y + x
  inc arr[index]
  if arr[index] == 2:
    inc val

proc findOverlaps(path: string, diags: static bool): int =
  var data: array[1000 * 1000, int]
  for line in path.lines:
    let (success, x1, y1, x2, y2) = line.scanTuple("$i,$i$s->$s$i,$i")
    if success:
      if (x1 == x2 or y1 == y2):
        for x in min(x1, x2)..max(x1, x2):
          for y in min(y1, y2)..max(y1, y2):
            addPoint(x, y, data, result)
      else:
        when diags:
          let
            xOffset = sgn(x2 - x1)
            yOffset = sgn(y2 - y1)
          var
            x = x1
            y = y1
          while x != x2 and y != y2:
            addPoint(x, y, data, result)
            x += xOffset
            y += yOffset
          addPoint(x, y, data, result)



echo findOverlaps("test.txt", false)
echo findOverlaps("test.txt", true)
echo findOverlaps("input.txt", false)
echo findOverlaps("input.txt", true)
