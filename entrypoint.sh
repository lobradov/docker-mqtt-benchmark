#!/bin/bash
#
# (c) Lazar Obradovic

if [ -z ${TARGETHOST} ]; then
  echo No TARGETHOST defined. Exiting.
  exit
fi

echo "Starting benchmark"

for clients in 1 2 4 8 16 32 64 128 256 512 1024 2048; do
  for size in 10 20 40 80 160 320 640; do
    echo -n "Testing with $clients clients and packet size of $size..."
    if [ -s /results/mqtt-benchmark-results-$clients-$size.json ]; then
      echo "\t existing, SKIPPED"
      continue
    fi
    mqtt-benchmark -broker tcp://$TARGETHOST:1883 -clients $clients -size $size -count 5000 -quiet -format json > /results/mqtt-benchmark-results-$clients-$size.json
    if [ $? -ne 0 ]; then
      echo "\t FAILED, exiting!"
      exit
    fi
    echo -n "\t finished!... sleeping 15s..."
    sleep 15s
    echo "\t DONE!"
  done
done