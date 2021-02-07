#!/bin/bash
###########################################
#
# Simple Shell script to clean/remove all container/images
#
# The script will 
#  - first stop all running containers (if any),
#  - remove containers
#  - remove images
#  - remove volumes
#

# Regular Colors
RED='\033[0;31m'
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # Whit

NC='\033[0m' # No Color
# printf "I ${Yellow}love${NC} Stack Overflow\n"

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

# read variables from .env file
APP_PATH=$(read_var APP_PATH .env)

countContainers() {
	docker ps -q $1 | wc -l
}

countNetworks() {
	docker network ls -q | wc -l
}

countImages() {
	docker image ls -q | wc -l
}

listContainers() {
    echo ''
    echo '-------------------------------------------------'
    echo ' Containers:'
    echo '-------------------------------------------------'
    docker ps
}

listImages() {
    echo ''
    echo '-------------------------------------------------'
    echo ' Images:'
    echo '-------------------------------------------------'
    docker image ls
}

listNetworks() {
    echo ''
    echo '-------------------------------------------------'
    echo ' Networks:'
    echo '-------------------------------------------------'
    docker network ls
}

listVolumes() {
    echo ''
    echo '-------------------------------------------------'
    echo ' Volumes:'
    echo '-------------------------------------------------'
    docker volume ls
}

# list containers
printf ${Purple}
echo '-------------------------------------------------'
echo ' Containers list'
echo '-------------------------------------------------'
printf "${NC}\n"
docker container ps

# list images
printf ${Blue}
echo '-------------------------------------------------'
echo ' Images list'
echo '-------------------------------------------------'
printf "${NC}\n"
docker images ls

# list volumes
printf ${Yellow}
echo '-------------------------------------------------'
echo ' Volumes list'
echo '-------------------------------------------------'
printf "${NC}\n"
docker volumes ls

# list networks
printf ${Cyan}
echo '-------------------------------------------------'
echo ' Networks list'
echo '-------------------------------------------------'
printf "${NC}\n"
docker networks ls

# stop all running containers
printf ${Red}
echo '-------------------------------------------------'
echo ' Stopping running containers (if available)...'
echo '-------------------------------------------------'
printf "${NC}\n"
docker stop $(docker ps -aq)

# remove all stopped containers
printf ${Red}
echo '-------------------------------------------------'
echo ' Removing containers ...'
echo '-------------------------------------------------'
printf "${NC}\n"
docker rm $(docker ps -aq)


# remove all images
printf ${Red}
echo '-------------------------------------------------'
echo ' Removing images ...'
echo '-------------------------------------------------'
printf "${NC}\n"
# docker rmi $(docker images -q)
# remove all images (force):
docker rmi $(docker images -a -q) -f

# remove all stray volumes if any
echo ''
echo '-------------------------------------------------'
echo ' Revoming docker container volumes (if any)'
echo '-------------------------------------------------'
printf "${NC}\n"
docker volume rm $(docker volume ls -q)

echo ''
echo ''
echo ''

COUNT_NETWORKS=countNetworks
echo $COUNT_NETWORKS
printf "appath: ${APP_PATH}\n"

listNetworks