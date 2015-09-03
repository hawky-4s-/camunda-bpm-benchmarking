#!/bin/bash
docker build -f docker/CamundaDockerfile -t ci1.camunda.loc:5000/camunda/camunda-bpm-platform:tomcat-7.4.0-alpha1-benchmark .
docker push ci1.camunda.loc:5000/camunda/camunda-bpm-platform:tomcat-7.4.0-alpha1-benchmark
