#!/usr/bin/env bash

# write STDIN to temp file
cat - > /tmp/assembly.fas
# merge all contigs into a single concatenated seqeunce
grep -v "^>" /tmp/assembly.fas | awk 'BEGIN { ORS=""; print ">merged_contigs\n" } { print }' > /tmp/assembly_merged.fas
# simulate reads from assembly
pirs simulate -l 100 -x 15 -m 500 -o assembly /tmp/assembly_merged.fas  > /dev/null 2>&1
# run seroba
seroba runSerotyping  --coverage 2 /seroba/database assembly_100_500_1.fq assembly_100_500_2.fq assembly  > /dev/null 2>&1
# output result
result=$(awk '{print $2}' assembly/pred.tsv)
jq --arg key0 'source' \
   --arg value0 'SEROBA' \
   --arg key1 'value' \
   --arg value1 $result \
    '. | .[$key0]=$value0 | .[$key1]=$value1 ' \
   <<<'{}'

