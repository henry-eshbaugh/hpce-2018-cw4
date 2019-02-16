#!/bin/bash
for i in 1 2 4 8 16 32
do
	cat w/random1M.bin | scripts/run_n512_P$i.sh | pv -afc 2>&1 >/dev/null | sed 's/[][]//g;s/B\/s\r//g' | numfmt --from=auto | tee results/P$i.dat
done

paste results/P1.dat results/P2.dat results/P4.dat results/P8.dat results/P16.dat results/P32.dat > all-P.tsv

for i in 1 2 4 8 16 32
do
	rm results/P$i.dat
done
