from __future__ import annotations
import sys

def add(a: int, b: int) -> int:
    return a + b

def main(argv=None) -> int:
    argv = argv or sys.argv[1:]
    if len(argv) != 2:
        print("Usage: ci-lab <a> <b>")
        return 2
    try:
        a, b = int(argv[0]), int(argv[1])
    except ValueError:
        print("Both arguments must be integers")
        return 2
    print(add(a, b))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
