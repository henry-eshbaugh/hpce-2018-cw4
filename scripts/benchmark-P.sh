#!/bin/bash
for i in 1 2 4 8 16 32
do
	  cat w/random1M.bin          \
	| scripts/run_n512_P$i.sh     \
       	| pv -afc 2>&1 >/dev/null     \
	| sed 's/[][]//g;s/B\/s\r//g' \
	| numfmt --from=auto          \
	| sed 's/\S*\(Ki\|Mi\)\S*//g' \
	| tee results/P$i.dat         
done

paste -s -d="\n" results/P1.dat results/P2.dat results/P4.dat results/P8.dat results/P16.dat results/P32.dat > all-Pp.tsv
printf "1\n2\n4\n8\n16\n32" > x.dat
paste x.dat all-Pp.tsv > results/all-P.tsv
rm x.dat all-Pp.tsv

for i in 1 2 4 8 16 32
do
	rm results/P$i.dat
done
