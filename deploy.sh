#!/bin/sh

HOST=$1
ECR_REGISTRY=$2
IMAGE_URL=$3
REGION=$4
LOG_GROUP=$5
LOG_STREAM=$6
CONTAINER_NAME=gateway

ssh \
    -o StrictHostKeyChecking=no \
    -i "private_key.pem" \
    $HOST \
<< EOF

aws ecr get-login-password | sudo docker login --username AWS --password-stdin $ECR_REGISTRY
sudo docker stop $CONTAINER_NAME
sudo docker system prune -a -f
sudo docker pull $IMAGE_URL
sudo docker run \
    --name $CONTAINER_NAME \
    -p 80:80 \
    -p 443:443 \
    -d \
    --add-host host.docker.internal:host-gateway \
    --restart always \
    $IMAGE_URL

EOF