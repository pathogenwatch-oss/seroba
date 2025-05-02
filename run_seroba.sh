#!/usr/bin/env bash

set -euo pipefail

COVERAGE=${PIRS_COVERAGE:-50}
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Write STDIN to temp file
cat - > "$TEMP_DIR/assembly.fas" || error_exit "Failed to write assembly to temp file"

echo "Written file, starting process" >&2

# Merge all contigs into a single concatenated sequence
grep -v "^>" "$TEMP_DIR/assembly.fas" |
    awk 'BEGIN { ORS=""; print ">merged_contigs\n" } { print }' > "$TEMP_DIR/assembly_merged.fas" ||
    error_exit "Failed to merge contigs"

echo "Merged contigs" >&2

# Simulate reads from assembly
pirs simulate -l 100 -x "$COVERAGE" -m 500 --no-substitution-errors --no-indel-errors \
    --no-gc-content-bias --threads=1 --random-seed=12345 -o "$TEMP_DIR/assembly" \
    "$TEMP_DIR/assembly_merged.fas"  ||
    error_exit "Failed to simulate reads"

echo "Simulated reads" >&2

# Run seroba
seroba runSerotyping --coverage $((COVERAGE * 2 / 5)) /seroba/database \
    "$TEMP_DIR/assembly_100_500_1.fq" "$TEMP_DIR/assembly_100_500_2.fq" "$TEMP_DIR/assembly" > /dev/null 2>&1 ||
    error_exit "Failed to run seroba"

echo "Ran seroba" >&2

# Write value to STDOUT
tail -n 1 "$TEMP_DIR/assembly/pred.csv" | awk -F ',' '{print $2}' ||
    error_exit "Failed to extract prediction"
