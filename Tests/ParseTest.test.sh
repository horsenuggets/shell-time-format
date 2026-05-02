#!/usr/bin/env bash
#
# ParseTest.test.sh
#
# Verifies time_format_parse handles the wide range of accepted inputs and
# correctly rejects malformed inputs.

source "$SHELLTEST_LIB"
source "$(dirname "$0")/../Source/ShellTimeFormat.sh"

describe "time_format_parse"

parse_eq() {
    local expected="$1"
    local input="$2"
    local got
    got="$(time_format_parse "$input")" || {
        echo "Parse failed for input '$input'."
        return 1
    }
    assert_equals "$expected" "$got"
}

parse_fails() {
    local input="$1"
    if time_format_parse "$input" >/dev/null 2>&1; then
        echo "Expected parse to fail for input '$input'."
        return 1
    fi
    return 0
}

it "parses 10s as 10" parse_eq 10 "10s"
it "parses 1m as 60" parse_eq 60 "1m"
it "parses 1h as 3600" parse_eq 3600 "1h"
it "parses 1d as 86400" parse_eq 86400 "1d"
it "parses 1h30m as 5400" parse_eq 5400 "1h30m"
it "parses uppercase 1H 30M" parse_eq 5400 "1H 30M"
it "parses spaced 1 H 30 M" parse_eq 5400 "1 H 30 M"
it "parses extra spaces" parse_eq 5400 "1    h30  m"
it "sums repeated units" parse_eq 3 "1s 1s 1s"
it "accepts units in any order" parse_eq 5400 "30m1h"
it "tolerates a trailing space" parse_eq 1 "1s "
it "tolerates a leading space" parse_eq 1 " 1s"
it "tolerates mixed case and order" parse_eq 90061 "1S 1M 1H 1D"

it "rejects empty input" parse_fails ""
it "rejects whitespace only" parse_fails "   "
it "rejects unitless number" parse_fails "60"
it "rejects unknown unit" parse_fails "5x"
it "rejects garbage" parse_fails "abc"
it "rejects unit without number" parse_fails "h"
it "rejects negative numbers" parse_fails "-1s"

write_results
