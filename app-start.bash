#!/bin/bash

ENV_FILE=.env

mkdir -p ${HOME}/onix/data/postgres
mkdir -p ${HOME}/onix/data/onix-api

source "custom.cfg" #This file is copied and renamed by github action job

gcloud secrets versions access latest --secret="acd-onix-${STAGE}-secrets" > secrets.cfg

cat custom.cfg > ${ENV_FILE}
cat secrets.cfg >> ${ENV_FILE}
echo "" >> ${ENV_FILE}
echo "DATA_DIR=${HOME}/onix/data" >> ${ENV_FILE} 

sudo docker-compose up -d

# apache2 user in the docker
sudo chown -R 69690:69690 ${HOME}/onix/data/onix-api
