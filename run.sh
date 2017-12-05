#!/bin/bash
#

TARGETHOST=192.168.86.199

if [[ ! -z $1 ]]; then
  TARGETHOST=$1
fi

mkdir -p `pwd`/results/${TARGETHOST}

docker run -it --rm -e TARGETHOST=${TARGETHOST} -v `pwd`/results:/results mqtt-benchmark:latest
