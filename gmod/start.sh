#!/bin/bash

# DB Password Setup
if [ -f "/run/secrets/db-password" ];
then
  mkdir -p /home/gmod-base/garrysmod/data/
  touch /home/gmod-base/garrysmod/data/dbp.txt
  cat /run/secrets/db-password >> /home/gmod-base/garrysmod/data/dbp.txt
fi

cd /home/gsrv/gmod-base

# If there should be a union, cd into unioned server files
if [ "${UNION}" -ne 0 ] && [ -n "${UNION}" ];
then
  unionfs-fuse -o cow /home/gsrv/gmod-data=RW:/home/gsrv/gmod-base=RO /home/gsrv/gmod-union
  cd /home/gsrv/gmod-union
fi

service ssh start
tmux new -s srv ./run-server.sh