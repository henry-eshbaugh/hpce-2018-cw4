#!/bin/bash
export TIMEFORMAT=%R
for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
do
	./bin/generate_sparse_layer $i 16 > w/ratio_$i.bin
	for j in simple par_for_naive par_for_atomic clustered par_for_clustered
	do
		echo "Benchmark ratio $i $j"
		cat w/random1M.bin \
		| { time ./bin/run_network w/ratio_$i.bin:$j >/dev/null ; } >>_ratio_$j.dat 2>&1
	done
done

paste _ratio_simple.dat _ratio_par_for_naive.dat _ratio_par_for_atomic.dat _ratio_clustered.dat _ratio_par_for_clustered.dat > all-ratio.tsv
printf "0.0625\n0.125\n0.25\n0.5\n1\n2\n4\n8\n16\n32\n64\n128\n256\n512\n1024\n2048\n4096" > x.dat
paste x.dat all-ratio.tsv > results/all-ratio.tsv
rm x.dat all-ratio.tsv

for j in simple par_for_naive par_for_atomic clustered par_for_clustered
do
	rm _ratio_$j.dat
done
