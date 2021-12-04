proc calculateConsumption(path: string, bitSize: static int): int =
  var gammaRate: array[bitSize, int]
  for line in path.lines:
    for i, ch in line:
      if ch == '1':
        inc gammaRate[i]
      elif ch == '0':
        dec gammaRate[i]

  var gVal, eVal: int
  for i, x in gammaRate:
    if x > 0:
      gVal = gVal or (1 shl (bitSize - 1 - i))
    if x <= 0:
      eVal = eVal or (1 shl (bitSize - 1 - i))
  eVal * gVal

echo calculateConsumption("test.txt", 5)
echo calculateConsumption("input.txt", 12)
