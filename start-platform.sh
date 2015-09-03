#!/bin/bash
VERSION=${1:-SNAPSHOT}
HOST=${2:-ci4.camunda.loc}
DB_HOST=${3:-192.168.178.106}
export DOCKER_HOST=tcp://$HOST:2375
unset DOCKER_TLS_VERIFY

docker rm -f -v camunda

docker run \
    -p 8080:8080 \
    -p 9090:9090 \
    -e TZ=Europe/Berlin \
    -e DB_DRIVER=org.postgresql.Driver \
    -e DB_URL=jdbc:postgresql://$DB_HOST:5432/process-engine \
    -e DB_USERNAME=camunda \
    -e DB_PASSWORD=camunda \
    -d \
    --name camunda \
    ci1.camunda.loc:5000/camunda/camunda-bpm-platform:tomcat-7.4.0-$VERSION-benchmark
