#!/bin/bash
VERSION=${1:-SNAPSHOT}
HOST=${2:-192.168.178.107} # ci4.camunda.loc
JMX_PORT=${3:-9090}
DB_HOST=${4:-ci3.camunda.loc}
export DOCKER_HOST=tcp://$HOST:2375
unset DOCKER_TLS_VERIFY

docker pull ci1.camunda.loc:5000/camunda/camunda-bpm-platform:tomcat-7.4.0-$VERSION-benchmark

echo "Starting camunda-bpm-platform:"

docker run \
    -p $JMX_PORT:$JMX_PORT \
    -e TZ=Europe/Berlin \
    -e DB_DRIVER=org.postgresql.Driver \
    -e DB_URL=jdbc:postgresql://$DB_HOST:5432/process-engine \
    -e DB_USERNAME=camunda \
    -e DB_PASSWORD=camunda \
    -e HOST=$HOST \
    -e JMX_PORT=$JMX_PORT \
    -d \
    ci1.camunda.loc:5000/camunda/camunda-bpm-platform:tomcat-7.4.0-$VERSION-benchmark

