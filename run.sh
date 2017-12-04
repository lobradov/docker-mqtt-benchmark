#!/bin/bash
#

TARGETHOST=192.168.86.199

if [[ ! -z $1 ]]; then
  TARGETHOST=$1
fi

if [ ! -d `pwd`/results ]; then
  echo No results directory here. Please create one - EXITING.
  exit
fi

docker run -it --rm -e TARGETHOST=$TARGETHOST -v `pwd`/results:/results mqtt-benchmark:latest
