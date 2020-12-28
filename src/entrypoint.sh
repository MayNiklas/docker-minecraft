#!/bin/bash
FILE=""
DIR="/app"
if [ "$(ls -A $DIR)" ]; then
     echo "$DIR is not Empty. Minecraft is allready installed"
else
    echo "$DIR is Empty. Minecraft is going to get installed"
    wget $serverurl
    java -jar server.jar
    sed -i 's/false/true/g' eula.txt 
fi

# Set groups and permissions
groupadd java -g ${GID:-1000}
useradd -u ${UID:-1000} -g ${GID:-1000} java
chown -R  java:java /app

su java -c 'java -Xmx$MC_RAM -jar server.jar'
