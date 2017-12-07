#!/bin/bash
#
# Simple script to generate CSV file that can be loaded to one of the graphing programs.

if [[ ! -z $1 ]]; then
  RESULTHOST=$1
fi

if [ ! -d results/${RESULTHOST} ]; then
  echo "ERROR: No results directory found (results/${RESULTHOST}). Exiting."
  exit
fi

# Header
echo "Number of concurrent clients, 10b max messages, 20b max messages, 40b max messages, 80b max messages, 160b max messages, 320b max messages, 640b max messages,"
for clients in 2 4 8 16 32 64 128 256 512 1024 2048; do
  echo -n ${clients},
  for size in 10 20 40 80 160 320 640; do
    if [ -s results/${RESULTHOST}/results-${clients}-${size}.json ]; then
      fgrep total_msgs_per_sec results/${RESULTHOST}/results-${clients}-${size}.json | awk ' {printf $2}'
    else
      echo -n ,
    fi
  done
  echo
done
