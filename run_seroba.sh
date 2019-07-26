#!/usr/bin/env bash

COVERAGE=${PIRS_COVERAGE:-50}

# write STDIN to temp file
cat - > /tmp/assembly.fas
# merge all contigs into a single concatenated seqeunce
grep -v "^>" /tmp/assembly.fas | awk 'BEGIN { ORS=""; print ">merged_contigs\n" } { print }' > /tmp/assembly_merged.fas
# simulate reads from assembly
pirs simulate -l 100 -x $COVERAGE -m 500 --no-substitution-errors --no-indel-errors --no-gc-content-bias --threads=1 --random-seed=12345 -o assembly /tmp/assembly_merged.fas  > /dev/null 2>&1
# run seroba
seroba runSerotyping --coverage $[$COVERAGE * 2/5] /seroba/database assembly_100_500_1.fq assembly_100_500_2.fq assembly  > /dev/null 2>&1
# write value to STDOUT
awk -F '\t' '{print $2}' assembly/pred.tsv
