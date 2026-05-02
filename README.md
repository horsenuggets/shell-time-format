# shell-time-format

A bash library for parsing and formatting human-friendly duration strings. Tolerates messy input like `1h30m`, `1H 30M`, `30m1h`, `1s 1s 1s`, and converts to and from a canonical `1h 30m`-style form.

## Usage

Add `shell-time-format` as a submodule:

```bash
git submodule add git@github.com:horsenuggets/shell-time-format.git Submodules/shell-time-format
```

Source it from your script:

```bash
source ./Submodules/shell-time-format/Source/ShellTimeFormat.sh

seconds=$(time_format_parse "1h 30m") || exit 1
echo "$seconds"                          # 5400

time_format_format 5400                  # 1h 30m
time_format_normalize "30m1h"            # 1h 30m
time_format_normalize "1S1M1H1D"         # 1d 1h 1m 1s
```

## API

- `time_format_parse INPUT` parses a duration string into a total integer number of seconds.
  Prints the integer to stdout on success. On invalid input, prints an error to stderr and
  returns 1.
- `time_format_format SECONDS` formats an integer number of seconds into the canonical
  `Xd Yh Zm Ws` form, omitting zero parts. `0` becomes `0s`. Negative values are rejected.
- `time_format_normalize INPUT` parses then formats, returning the canonical form for any
  accepted input.

## Accepted Input

- Units: `s` (seconds), `m` (minutes), `h` (hours), `d` (days). Case-insensitive.
- Whitespace anywhere is ignored, including between digits and units.
- Multiple segments combine in any order. Repeated units sum.

## Rejected Input

- Empty or whitespace-only input.
- Bare numbers without a unit.
- Unknown units or any non-digit, non-unit, non-whitespace character.
- Negative values.

## License

MIT
