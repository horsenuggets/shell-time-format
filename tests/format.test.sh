#!/usr/bin/env bash
#
# format.test.sh
#
# Verifies time_format_format produces canonical human-readable strings.

source "$SHELLTEST_LIB"
source "$(dirname "$0")/../src/shell-time-format.sh"

describe "time_format_format"

format_eq() {
    local expected="$1"
    local seconds="$2"
    local got
    got="$(time_format_format "$seconds")" || {
        echo "Format failed for seconds '$seconds'."
        return 1
    }
    assert_equals "$expected" "$got"
}

format_fails() {
    local seconds="$1"
    if time_format_format "$seconds" >/dev/null 2>&1; then
        echo "Expected format to fail for seconds '$seconds'."
        return 1
    fi
    return 0
}

it "formats zero" format_eq "0s" 0
it "formats single seconds" format_eq "5s" 5
it "formats single minute" format_eq "1m" 60
it "formats minutes and seconds" format_eq "1m 30s" 90
it "formats single hour" format_eq "1h" 3600
it "formats hours and minutes" format_eq "1h 30m" 5400
it "formats hours minutes seconds" format_eq "1h 1m 1s" 3661
it "formats days" format_eq "1d" 86400
it "formats full breakdown" format_eq "1d 1h 1m 1s" 90061
it "skips zero parts" format_eq "2d 30s" 172830

it "rejects non-integers" format_fails "abc"
it "rejects negatives" format_fails "-5"

write_results
