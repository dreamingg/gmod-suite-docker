# Gmod Dev Server Docker

Developer setup for Garry's Mod servers w/ MySQL.

This Docker setup uses docker-compose to run a [Garry's Mod](https://gmod.facepunch.com/) server, and a [MariaDB (MySQL)](https://mariadb.org/) server with [phpMyAdmin](https://www.phpmyadmin.net/). Supports GMod x64 beta branch.

Takes inspiration from [suchipi/gmod-server-docker](https://github.com/suchipi/gmod-server-docker) and uses [rpodgorny/unionfs-fuse](https://github.com/rpodgorny/unionfs-fuse) to unionize a docker volume on top of the vanilla Garry's Mod server files.

The base files in the container are untouched, but anytime the server writes to a file, it will write it to the docker volume persisting it there. You can also place files here to add or develop addons.

Automatically installs [MySQLOO](https://github.com/FredyH/MySQLOO/) and writes connection credentials in `garrysmod/data/dbp.txt`

## Using

Make sure [Docker is installed](https://docs.docker.com/engine/install/)

Clone the repo:

```
git clone https://github.com/DreaminGG/GMod-Suite-Docker.git
```

Copy `.env.example` into `.env` and configure the values. Mount Dir is a local path designating what to mount as the docker volume.

### Container Setup

To build the container, enter the directory and run the command:

```bash
docker compose build
```

You should only need to build this once unless you change the CPU Architecture.

To start the containers/servers, run the command:

```bash
docker compose up -d
```

You can switch the docker volume mount on the fly if you stop the volume using this command:

`(-v flag is important to reset volumes)`

```bash
docker compose down -v
```

Then changing `GMOD_MOUNT_DIR` in your `.env` file to the new directory, then starting the containers again. 

You can also specify a separate env file:

```bash
docker compose up -d --env-file .env.ttt
```

This way, you can have multiple server 'profiles' without multiple separate server installations.

### Accessing Console

To access the GMod server console you just need to attach to the docker container.

Running this script will do that for you:

```bash
./console.sh
```

## Environment Variables

There are several environment variables you can use to change server settings or startup parameters:

| Key            | Desc                                                                                                                 | Default        |
|----------------|----------------------------------------------------------------------------------------------------------------------|----------------|
| CPU_ARCH       | GMod server architecture (x64 beta, `x64`)                                                                           | `i384` (x32)   |
| PORT           | Gmod Server port                                                                                                     | `27015`        |
| GMOD_MOUNT_DIR | Mounting directory for the unioned GMod docker volume                                                                ||
| GMOD_HOSTNAME  | Garry's Mod Server hostname                                                                                          | `Garry's Mod`  |
| MAXPLAYERS     | Max player count                                                                                                     | `20`           |
| TICKRATE       | Server CPU tickrate                                                                                                  | `66`           |
| GAMEMODE       | Server Gamemode                                                                                                      | `sandbox`      |
| MAP            | Starting map                                                                                                         | `gm_construct` |
| ARGS           | Additional gmod server startup args                                                                                  ||
| AUTOUPDATE     | Check for updates everytime the server starts using -autoupdate                                                      | `0`            |
| UNION          | Wether to enable docker volume union                                                                                 | `1`            |
| GSLT           | Game server account token, [Required for public servers](https://wiki.facepunch.com/gmod/Steam_Game_Server_Accounts) ||