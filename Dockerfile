FROM golang:alpine
MAINTAINER Lazar Obradovic <laz.obradovic@gmail.com>

ENV TARGETHOST="127.0.0.1"
RUN apk add --update --virtual build-dependencies \
  git

RUN go get github.com/krylovsk/mqtt-benchmark

RUN apk del build-dependencies \
  && rm -rf /var/cache/apk

VOLUME [ "/results" ]
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
