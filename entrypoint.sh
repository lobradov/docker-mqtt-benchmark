#!/bin/sh
#
# (c) Lazar Obradovic

if [ -z ${TARGETHOST} ]; then
  echo No TARGETHOST defined. Exiting.
  exit
fi

if snmpget -v2c -c public -O q $TARGETHOST laLoadInt.1 > /dev/null 2>&1; then
  # SNMP available, good.
  snmp_available=1
  snmp_initload=`snmpget -v2c -c public -O q $TARGETHOST laLoadInt.1 | awk '{ print $2}'`
  if [ $snmp_initload -ge 20 ]; then
    echo "ERROR: DUT load too high ($snmp_initload %) - try again later."
    exit
  fi
  #  for very idle systems,we might get 0%, which will be hard to meet
  if [ $snmp_initload -le 2 ]; then $snmp_initload=2; fi
  echo "INFO: DUT CPU load is $snmp_initload %"
  sleep 5s
else
  snmpavailable=0
  # Sleep using backoff algo.
fi

echo "INFO: Starting benchmark"

for clients in 1 2 4 8 16 32 64 128 256 512 1024 2048; do
  for size in 10 20 40 80 160 320 640; do
    echo -n "INFO: Testing with $clients client(s) and packet size of $size..."
    if [ -s /results/results-$clients-$size.json ]; then
      echo "existing, SKIPPED"
      continue
    fi
    mqtt-benchmark -broker tcp://$TARGETHOST:1883 -clients $clients -size $size -count 5000 -quiet -format json > /results/results-$clients-$size.json
    if [ $? -ne 0 ]; then
      rm /results/results-$clients-$size.json
      echo "FAILED, exiting!"
      exit
    fi
    echo -n "finished!"
    if [ $snmp_available -eq 1 ]; then
      echo -n " ... waiting for DUT to cool off"
      snmp_load=`snmpget -v2c -c public -O q $TARGETHOST laLoadInt.1 | awk '{ print $2}'`
      until [ $snmp_initload -ge $snmp_load ]; do
        sleep 20s
        echo -n "."
        snmp_load=`snmpget -v2c -c public -O q $TARGETHOST laLoadInt.1 | awk '{ print $2}'`
      done
      echo ".DONE!"
    else
      sleeptime=$((15 + clients/32 + size/10))
      echo -n "... sleeping $sleeptime"
      sleep $sleeptime
      echo ".DONE!"
    fi
  done
done
