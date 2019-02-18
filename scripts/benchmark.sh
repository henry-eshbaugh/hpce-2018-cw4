#!/bin/bash
echo "Generating 1M file..."
cat /dev/urandom | head -c 1048576 > w/random1M.bin
echo "-------------------------------------"
echo " -> Benchmark P"
bash scripts/benchmark-P.sh
echo "-------------------------------------"
echo " -> Benchmark IR"
bash scripts/benchmark-ir.sh
echo "-------------------------------------"
echo " -> Benchmark N"
bash scripts/benchmark-n.sh
echo "-------------------------------------"
echo " -> Done. Generating graphs..."
cat scripts/graphs.gpi | gnuplot
