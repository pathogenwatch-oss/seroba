#!/usr/bin/env bash

# write STDIN to temp file
cat - > /tmp/assembly.fas
# merge all contigs into a single concatenated seqeunce
grep -v "^>" /tmp/assembly.fas | awk 'BEGIN { ORS=""; print ">merged_contigs\n" } { print }' > /tmp/assembly_merged.fas
# simulate reads from assembly
pirs simulate -l 100 -x 50 -m 500 -o assembly /tmp/assembly_merged.fas
# run seroba
seroba runSerotyping /seroba/databse assembly_100_500_1.fq assembly_100_500_2.fq assembly
# output result
cat assembly/pred.tsv

