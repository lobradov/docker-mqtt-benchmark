# docker-mqtt-benchmark

Docker wrapper for MQTT Benchmark (krylovsk/mqtt-benchmark) and a script to iterate over the number of different parameters so we can build a nice 3D graph of clients/message-size/latency dependency.

## Building 
``` ./build.sh ```

## Running 
``` ./run.sh [mqtt_hostname]```

Default MQTT server is 192.168.86.199 (my home setup ;), feel free to edit ./run.sh to change default.
