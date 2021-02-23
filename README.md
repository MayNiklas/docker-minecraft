# docker-minecraft

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the minecraft docker container with the following command:
```
docker run --rm -d \
    -p "25565:25565/tcp" \
    -v $(pwd)/data:/app \
    --name minecraft-server \
    mayniki/minecraft
```

Where:
  - `$(pwd)/data:/app`: This is where the application get's installed. In this case, your current directory is used.

## Environment Variables

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`serverurl`| Insert a download link to the server.jar file | 'NULL' |
|`MC_RAM`| How much RAM is the java application allowed to use? | `2G` |
|`UID`| ID of the user the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |
|`GID`| ID of the group the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |

## docker-compose.yml

Here is an example of a `docker-compose.yml` file that can be used with
[Docker Compose](https://docs.docker.com/compose/overview/).

Make sure to adjust according to your needs.

The file can be found within the repository and is getting cloned within it.
Therefore: docker-compose up should work out of the box.


```
version: '3.0'
services:
  minecraft-server:
    container_name: minecraft-server
    image: mayniki/minecraft
    volumes:
      - "./data:/app"
    ports:
      - "25565:25565"
    environment:
      - MC_RAM=2G
      - serverurl=
      - UID=1000 
      - GID=1000
    stdin_open: true
    tty: true
    restart: unless-stopped
```

### minecraft shell
Sometimes you need to get access to the servers shell.
```bash
# stop the server
docker-compose down

# start the container with a modified entrypoint
docker run -p 25565:25565 -v $(pwd)/app/:/app -it --entrypoint="bash" mayniki/minecraft

# start minecraft under user java
groupadd java -g 1000
useradd -u 1000 -g 1000 java
chown -R  java:java /app
su java -c 'java -Xmx4G -jar server.jar'

# after being done in the shell
/stop
exit

# now restart the server normally
docker-compose up -d
```

## Backup
I personally use the following skript to backup my server before I migrate it to another system.
```bash
#!/bin/bash

cd ~/docker/minecraft/

# Pulling the new image for security reasons only
docker-compose pull

# Creating a variable containing the date
now=`date +"%Y-%m-%d-%H-%M"`
echo "${now}"

# Creating a backup folder
mkdir backup

# Stopping the minecraft server
docker-compose down

# Creating a zip file
zip -r backup/${now}-minecraft.zip app docker-compose.yml

# Restart the minecraft server
docker-compose up -d
```

## Restoring backup
The container is written in a way, permissions are being handled while starting.
```bash
#!/bin/bash

cd ~/docker/minecraft/

# stopping the minecraft server
docker-compose down

# it might be a good idea to create a backup first!
now=`date +"%Y-%m-%d-%H-%M"`
zip -r backup/${now}-minecraft.zip app docker-compose.yml

# I suggest completly deleting the old app folder
rm -rf app/

# unzip your backup
unzip backup/2021-02-24-00-22-minecraft.zip

# Restart the minecraft server
docker-compose up -d
```
