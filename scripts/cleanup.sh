#!/bin/bash
# Remove old containers
docker ps -aq --filter "status=exited" | xargs docker rm
# Clean unused images
docker images -q --filter "dangling=true" | xargs docker rmi
