#!/bin/bash
export TIMEFORMAT=%R
for i in 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
do
	./bin/generate_sparse_layer $i $i > w/scaling_$i.bin
	for j in simple par_for_naive par_for_atomic clustered par_for_clustered
	do
		echo "Benchmark dimension $i $j"
		cat w/random1M.bin \
		| { time ./bin/run_network w/scaling_$i.bin:$j >/dev/null ; } >>_scaling_$j.dat 2>&1
	done
	echo $i >> x.dat
done

paste _scaling_simple.dat _scaling_par_for_naive.dat _scaling_par_for_atomic.dat _scaling_clustered.dat _scaling_par_for_clustered.dat > all-scaling.tsv
paste x.dat all-scaling.tsv > results/all-scaling.tsv
rm x.dat all-scaling.tsv

for j in simple par_for_naive par_for_atomic clustered par_for_clustered
do
	rm _scaling_$j.dat
done
