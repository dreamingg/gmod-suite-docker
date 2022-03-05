#!/bin/bash

echo "-"
echo "Entering Garry's Mod console from docker container"
echo "IMPORTANT: To detach from the session, Hold CTRL, then press P and Q"
echo "-"

read -n 1 -s -r -p "Press any key to continue"

CONTAINER_ID=$(docker ps | grep _gmod | cut -d ' ' -f1)
docker attach ${CONTAINER_ID}