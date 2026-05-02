#!/usr/bin/env bash
#
# ShellTimeFormat.sh
#
# Library for parsing and formatting human-friendly duration strings. Source
# this file to expose `time_format_parse`, `time_format_format`, and
# `time_format_normalize`.
#
# Supported units: s (seconds), m (minutes), h (hours), d (days). Input is
# case-insensitive, whitespace-tolerant, and accepts multiple segments in any
# order (e.g., "1h30m", "30m1h", "1H 30 M", "1s 1s 1s").

# Parse a duration string into a total number of seconds.
#
# On success, prints the integer total to stdout and returns 0.
# On failure, prints an error message to stderr and returns 1.
time_format_parse() {
    local input="$1"

    # Lowercase and strip every whitespace character.
    local cleaned
    cleaned="$(printf '%s' "$input" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"

    if [[ -z "$cleaned" ]]; then
        echo "Invalid duration. Input is empty." >&2
        return 1
    fi

    if [[ ! "$cleaned" =~ ^([0-9]+[smhd])+$ ]]; then
        echo "Invalid duration '$input'. Expected format like '1h30m' or '10s'." >&2
        return 1
    fi

    local total=0
    local remaining="$cleaned"
    while [[ -n "$remaining" ]]; do
        # Match leading digits.
        local digits="${remaining%%[!0-9]*}"
        remaining="${remaining#"$digits"}"
        local unit="${remaining:0:1}"
        remaining="${remaining:1}"

        local seconds
        case "$unit" in
            s) seconds=$((10#$digits)) ;;
            m) seconds=$((10#$digits * 60)) ;;
            h) seconds=$((10#$digits * 3600)) ;;
            d) seconds=$((10#$digits * 86400)) ;;
            *)
                echo "Invalid duration '$input'. Unknown unit '$unit'." >&2
                return 1
                ;;
        esac
        total=$((total + seconds))
    done

    echo "$total"
}

# Format a total number of seconds into a human-friendly string.
#
# Examples: 0 -> "0s", 59 -> "59s", 60 -> "1m", 90 -> "1m 30s",
# 3600 -> "1h", 5400 -> "1h 30m", 90061 -> "1d 1h 1m 1s".
time_format_format() {
    local total="$1"

    if [[ ! "$total" =~ ^-?[0-9]+$ ]]; then
        echo "Invalid seconds '$total'. Expected an integer." >&2
        return 1
    fi

    if [[ $total -lt 0 ]]; then
        echo "Invalid seconds '$total'. Must be non-negative." >&2
        return 1
    fi

    if [[ $total -eq 0 ]]; then
        echo "0s"
        return 0
    fi

    local days=$((total / 86400))
    local rem=$((total % 86400))
    local hours=$((rem / 3600))
    rem=$((rem % 3600))
    local minutes=$((rem / 60))
    local seconds=$((rem % 60))

    local parts=()
    [[ $days -gt 0 ]] && parts+=("${days}d")
    [[ $hours -gt 0 ]] && parts+=("${hours}h")
    [[ $minutes -gt 0 ]] && parts+=("${minutes}m")
    [[ $seconds -gt 0 ]] && parts+=("${seconds}s")

    echo "${parts[*]}"
}

# Normalize a messy duration string by parsing then formatting it. Returns the
# canonical representation, or returns 1 with an error message on bad input.
time_format_normalize() {
    local seconds
    seconds="$(time_format_parse "$1")" || return 1
    time_format_format "$seconds"
}
