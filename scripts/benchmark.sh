#!/bin/bash
bash scripts/benchmark-P.sh
bash scripts/benchmark-ir.sh
bash scripts/benchmark-n.sh
cat scripts/graphs.gpi | gnuplot
