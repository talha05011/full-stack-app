#!/bin/bash
SERVICE=$1
HEALTH_PORT=$2

if ! docker inspect --format='{{.State.Health.Status}}' $SERVICE | grep -q "healthy"; then
    echo "Rolling back $SERVICE..."
    docker stop $SERVICE && docker rm $SERVICE
    docker run -d --name $SERVICE ${SERVICE}:stable
fi
