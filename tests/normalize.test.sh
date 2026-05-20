#!/usr/bin/env bash
#
# normalize.test.sh
#
# Verifies time_format_normalize round-trips messy input into canonical form.

# shellcheck source=/dev/null
source "$SHELLTEST_LIB"
# shellcheck source=/dev/null
source "$(dirname "$0")/../src/shell-time-format.sh"

describe "time_format_normalize"

normalize_eq() {
    local expected="$1"
    local input="$2"
    local got
    got="$(time_format_normalize "$input")" || {
        echo "Normalize failed for input '$input'."
        return 1
    }
    assert_equals "$expected" "$got"
}

it "canonicalizes 1h30m" normalize_eq "1h 30m" "1h30m"
it "canonicalizes spaced uppercase" normalize_eq "1h 30m" "1H 30M"
it "canonicalizes reordered units" normalize_eq "1h 30m" "30m1h"
it "sums repeated units" normalize_eq "3s" "1s 1s 1s"
it "trims whitespace" normalize_eq "1s" "1s "
it "expands all units" normalize_eq "1d 1h 1m 1s" "1S1M1H1D"

write_results
