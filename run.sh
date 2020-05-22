#! /bin/bash
set -exu
[ $# -eq 0 ]

sudo             -- \
nice -n +20      -- \
sudo -u `whoami` -- \
docker-compose build

docker push innovanon/docker-apt-cacher-ng:latest || :

sudo             -- \
nice -n +20      -- \
sudo -u `whoami` -- \
docker-compose up --force-recreate -d

