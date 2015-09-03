# camunda-bpm-benchmarking

## Usage

cAdvisor for collecting Postgresql container metrics

```
curl -sSL ‘http://${HOST}:8080/api/v1.0/containers/system.slice/docker-${FULL_CONTAINER_ID}.scope’  --data ‘{“num_stats”:-1,”num_samples”:0}’ | jq ‘.stats | .[]
```
