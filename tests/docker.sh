#!/bin/bash
# test Release provisiones with Ansible

ANSIBLE_ROLE="aplyca.Release"
DOCKER_IMAGE="ansible/ubuntu14.04-ansible"

docker run -it --name test-release -v `pwd`:/tmp/${ANSIBLE_ROLE} ${DOCKER_IMAGE} /tmp/${ANSIBLE_ROLE}/tests/tests.sh
docker stop test-release && docker rm test-release
