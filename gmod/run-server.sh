#!/bin/bash

# Optional Auto updating handled by SrcDS
if [ "${AUTOUPDATE}" -ne 0 ] && [ -n "${AUTOUPDATE}" ];
then
    ARGS= "-autoupdate
       -steam_dir \"/home/gsrv/steamcmd\"
       -steamcmd_script \"/home/gsrv/scripts/update.script\"
       ${ARGS}"
fi

#while true; do
  # Echo commands that are executed
set -x

# Starts the Garry's Mod server
# This file can be overridden in the /gmod-data Docker Volume
./srcds_run \
    -game garrysmod \
    -norestart \
    -strictportbind \
    -tickrate "${TICKRATE}" \
    -port "27015" \
    +maxplayers "${MAXPLAYERS}" \
    +gamemode "${GAMEMODE}" \
    +sv_setsteamaccount "${STEAM_GSLT}" \
    "${ARGS}" \
    +map "${MAP}"

set +x
#done