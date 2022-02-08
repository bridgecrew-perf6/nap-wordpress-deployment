#!/bin/bash

# $1 is branch name

BRANCH=$1
OPTION=StrictHostKeyChecking=no
ZONE=asia-southeast1-b

SA_KEY=sa-dev.json
KEY_FILE=gce-dev.key
HOST=nap-wordpress-gce-dev-001
PROJECT=nap-devops-nonprod

source "custom-${BRANCH}.cfg"
REMOTE_DIR=/home/devops/wordpress-${STAGE}

if [ "${BRANCH}" == "production" ]; then
    SA_KEY=sa-prod.json
    KEY_FILE=gce-prod.key
    HOST=nap-wordpress-gce-prod-001
    PROJECT=nap-devops-prod
fi
PATH_SPEC=devops@${HOST}:${REMOTE_DIR}
USER_SPEC=devops@${HOST}

gcloud auth activate-service-account --key-file=${SA_KEY}

echo "##### start"
gcloud compute ssh ${USER_SPEC} --tunnel-through-iap --quiet --project=${PROJECT} --zone=${ZONE} --command="mkdir -p ${REMOTE_DIR}"
echo "##### end"

# DO NOT cat any private key here
gcloud compute scp --tunnel-through-iap --quiet --project=${PROJECT} --zone=${ZONE} app-start.bash ${PATH_SPEC}
gcloud compute scp --tunnel-through-iap --quiet --project=${PROJECT} --zone=${ZONE} custom-${BRANCH}.cfg ${PATH_SPEC}/custom.cfg
gcloud compute scp --tunnel-through-iap --quiet --project=${PROJECT} --zone=${ZONE} docker-compose.yaml ${PATH_SPEC}

gcloud compute ssh ${USER_SPEC} --tunnel-through-iap --quiet --project=${PROJECT} --zone=${ZONE} \
    --command="cd ${REMOTE_DIR}; chmod +x app-start.bash; ./app-start.bash"
