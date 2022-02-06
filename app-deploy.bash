#!/bin/bash

# $1 is branch name

BRANCH=$1
REMOTE_DIR=/home/devops/wordpress
OPTION=StrictHostKeyChecking=no
ZONE=asia-southeast1-b

KEY_FILE=gce-dev.key
HOST=nap-wordpress-gce-dev-001
if [ "${BRANCH}" == "production" ]; then
    KEY_FILE=gce-prod.key
    HOST=nap-wordpress-gce-prod-001
fi
PATH_SPEC=devops@${HOST}:${REMOTE_DIR}
USER_SPEC=devops@${HOST}

#ssh -i ${KEY_FILE} -o ${OPTION} ${USER_SPEC} mkdir -p ${REMOTE_DIR}
gcloud compute ssh ${USER_SPEC} --ssh-key-file=${KEY_FILE} --tunnel-through-iap \
    --quiet --zone=${ZONE} --command="mkdir -p ${REMOTE_DIR}"

# DO NOT cat any private key here
gcloud compute scp --ssh-key-file=${KEY_FILE} --tunnel-through-iap --quiet --zone=${ZONE} app-start.bash ${PATH_SPEC}
gcloud compute scp --ssh-key-file=${KEY_FILE} --tunnel-through-iap --quiet --zone=${ZONE} custom-${BRANCH}.cfg ${PATH_SPEC}/custom.cfg
gcloud compute scp --ssh-key-file=${KEY_FILE} --tunnel-through-iap --quiet --zone=${ZONE} docker-compose.yaml ${PATH_SPEC}

#ssh -i ${KEY_FILE} -o ${OPTION} ${USER_SPEC} "cd ${REMOTE_DIR}; ./app-start.bash"
gcloud compute ssh ${USER_SPEC} --ssh-key-file=${KEY_FILE} --tunnel-through-iap \
    --quiet --zone=${ZONE} --command="cd ${REMOTE_DIR}; ./app-start.bash"
