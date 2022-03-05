FROM ubuntu:20.04
LABEL maintainer = "Ethan Jones <ethan@dreamin.gg>"

# -
# Env setup

ENV DEBIAN_FRONTEND=noninteractive

# Defaults
ENV PORT="27015"
ENV MAXPLAYERS="20"
ENV TICKRATE="66"
ENV GMOD_HOSTNAME="Garry's Mod"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"
ENV GSLT=""
ENV AUTOUPDATE=0
ENV UNION=1

# -
# Set up Workspace, User Libraries, SteamCMD

USER root

# - Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# - Install dependencies
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y --no-install-recommends --no-install-suggests install \
    lib32gcc1 libgcc1 libstdc++6 lib32stdc++6 libc6 libncurses5 libtinfo5 \
    ca-certificates unionfs-fuse curl tmux locales

# - Unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

# - Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# - Setup SteamCMD

RUN mkdir -p /home/gsrv/steamcmd
WORKDIR /home/gsrv/steamcmd

RUN curl -L https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -s -o - | tar zxv

# -
# Garry's Mod Server & Counter-Strike: Source content

RUN mkdir -p /home/gsrv/scripts

ADD steamscript/update-x64.script /home/gsrv/scripts/update.script
ADD cfg/mount.cfg /home/gsrv/gmod-base/garrysmod/cfg/

RUN mkdir -p /home/gsrv/gmod-base/

# - Install
RUN ./steamcmd.sh +force_install_dir /home/gsrv/gmod-base +login anonymous +app_update 4020 -beta x86-64 validate +quit
RUN ./steamcmd.sh +force_install_dir /home/gsrv/css +login anonymous +app_update 232330 validate +quit

# - Library fixes
RUN mkdir -p /home/gsrv/gmod-libs
RUN mkdir -p /home/gsrv/gmod-base/bin
WORKDIR /home/gsrv/gmod-libs

RUN curl -O http://launchpadlibrarian.net/195509222/libc6_2.15-0ubuntu10.10_i386.deb -s
RUN dpkg -x libc6_2.15-0ubuntu10.10_i386.deb .
RUN cp lib/i386-linux-gnu/* /home/gsrv/gmod-base/bin

WORKDIR /home/gsrv/steamcmd
RUN rm -rf /home/gsrv/gmod-libs

RUN cp linux32/libstdc++.so.6 /home/gsrv/gmod-base/bin

RUN mkdir -p /home/gsrv/.steam/sdk64
RUN cp linux64/steamclient.so /home/gsrv/.steam/sdk64

# -
# MySQLOO Setup

RUN mkdir -p /home/gsrv/gmod-base/garrysmod/lua/bin
WORKDIR /home/gsrv/gmod-base/garrysmod/lua/bin

RUN curl -O -L https://github.com/FredyH/MySQLOO/releases/download/9.7.2/gmsv_mysqloo_linux.dll -s

# -
# Setup Volume & Union

WORKDIR /home/gsrv

RUN mkdir /home/gsrv/gmod-data
VOLUME /home/gsrv/gmod-data
RUN mkdir /home/gsrv/gmod-union

# -
# Setup Container

ADD --chown=steam:steam start.sh /home/gsrv/start.sh
ADD --chown=steam:steam run-server.sh /home/gsrv/gmod-base/run-server.sh

EXPOSE 27015
EXPOSE 27015/udp
EXPOSE 27005/udp

CMD ["/bin/bash", "/home/gsrv/start.sh"]