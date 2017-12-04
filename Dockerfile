FROM golang:alpine
MAINTAINER Lazar Obradovic <laz.obradovic@gmail.com>

ENV TARGETHOST="127.0.0.1"
RUN go get github.com/krylovsk/mqtt-benchmark
VOLUME [ "/results" ]
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
