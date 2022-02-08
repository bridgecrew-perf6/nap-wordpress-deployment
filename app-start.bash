#!/bin/bash

ENV_FILE=.env

source "custom.cfg" #This file is copied and renamed by github action job

mkdir -p ${HOME}/wordpress-${STAGE}/data

gcloud secrets versions access latest --secret="nap-wordpress-${STAGE}-secrets" > secrets.cfg

cat custom.cfg > ${ENV_FILE}
echo "" >> ${ENV_FILE}

cat secrets.cfg >> ${ENV_FILE}
echo "" >> ${ENV_FILE}

echo "DATA_DIR=${HOME}/wordpress-${STAGE}/data" >> ${ENV_FILE} 

sudo docker-compose up -d
