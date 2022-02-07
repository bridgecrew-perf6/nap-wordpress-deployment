#!/bin/bash

#TODO : Added mechanism to auto start "docker-compose up" if VM is restarted

ENV_FILE=.env

mkdir -p ${HOME}/wordpress/data/postgres
mkdir -p ${HOME}/wordpress/data/wordpress

source "custom.cfg" #This file is copied and renamed by github action job

gcloud secrets versions access latest --secret="nap-wordpress-${STAGE}-secrets" > secrets.cfg

cat custom.cfg > ${ENV_FILE}
cat secrets.cfg >> ${ENV_FILE}
echo "" >> ${ENV_FILE}
echo "DATA_DIR=${HOME}/wordpress/data" >> ${ENV_FILE} 

sudo docker-compose up -d
