import std/strutils
import slicerator

proc getChanges(input: string): (int, int) =
  let
    file = open(input)
    data = file.lines.map(parseInt)
  if data[^2] < data[^1]:
    inc result[0]
  if data[^3] < data[^2]:
    inc result[0]
  for a, b, c, d in groups(data, true):
    if a < b:
      inc result[0]
    if a < d:
      inc result[1]
  file.close

echo getChanges("test.txt")
echo getChanges("input.txt")
