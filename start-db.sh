#!/bin/bash
HOST=${1:-ci3.camunda.loc}
export DOCKER_HOST=tcp://$HOST:2375
unset DOCKER_TLS_VERIFY

echo "Removing old containers..."
docker rm -f -v postgresql
docker rm -f -v cadvisor

sleep 5

echo "\nStarting postgresql on $HOST:5432"

docker run \
    --cpuset-cpus="0,2" \
    --cpu-quota 50000 \
    -p 5432:5432 \
    -e POSTGRES_USER=camunda \
    -e POSTGRES_PASSWORD=camunda \
    -e POSTGRES_DB=process-engine \
    -d \
    --name postgresql \
    postgres:9.4.4

echo "\nStarting cadvisor on http://$HOST:8080"

docker run \
    -d \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --publish=8080:8080 \
    --name=cadvisor \
    google/cadvisor:latest -storage_duration=60m0s

