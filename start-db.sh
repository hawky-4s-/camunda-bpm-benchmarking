#!/bin/bash
HOST=${1:-ci3.camunda.loc}
export DOCKER_HOST=tcp://$HOST:2375
unset DOCKER_TLS_VERIFY

docker rm -f -v postgresql
docker rm -f -v cadvisor

sleep 10

docker run \
    --cpuset-cpus="0" \
    --cpu-quota 10000 \
    -p 5432:5432 \
    -e POSTGRES_USER=camunda \
    -e POSTGRES_PASSWORD=camunda \
    -e POSTGRES_DB=process-engine \
    -d \
    --name postgresql \
    postgres:9.4.4

docker run -d --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --publish=8080:8080 --name=cadvisor google/cadvisor:latest -storage_duration=60m0s

