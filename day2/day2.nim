import std/strscans

proc plotCourse(path: string, aimMethod: static bool = false): int =
  var x, y: int
  when aimMethod:
    var aim = 0
  for line in lines(path):
    let (success, dir, val) = line.scanTuple("$+ $i")
    if success:
      case dir
      of "up":
        when aimMethod:
          aim -= val
        else:
          y -= val
      of "down":
        when aimMethod:
          aim += val
        else:
          y += val
      of "forward":
        when aimMethod:
          x += val
          y += aim * val
        else:
          x += val
      else: echo line
    else:
      echo line
  echo x, " ", y
  result = x * y

echo plotCourse("test.txt")
echo plotCourse("test.txt", true)

echo plotCourse("input.txt")

echo plotCourse("input.txt", true)
