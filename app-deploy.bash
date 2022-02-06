#!/bin/bash

# $1 is branch name

BRANCH=$1
REMOTE_DIR=/home/devops/wordpress
OPTION=StrictHostKeyChecking=no

KEY_FILE=gce-dev.key
HOST=onix-api.acd-np.its-software-services.com
if [ "${BRANCH}" == "production" ]; then
    KEY_FILE=gce-prod.key
    HOST=onix-api.acd.its-software-services.com
fi
PATH_SPEC=devops@${HOST}:${REMOTE_DIR}
USER_SPEC=devops@${HOST}

ssh -i ${KEY_FILE} -o ${OPTION} ${USER_SPEC} mkdir -p ${REMOTE_DIR}

# DO NOT cat any private key here
scp -i ${KEY_FILE} -o ${OPTION} app-start.bash ${PATH_SPEC}
scp -i ${KEY_FILE} -o ${OPTION} custom-${BRANCH}.cfg ${PATH_SPEC}/custom.cfg
scp -i ${KEY_FILE} -o ${OPTION} docker-compose.yaml ${PATH_SPEC}

ssh -i ${KEY_FILE} -o ${OPTION} ${USER_SPEC} "cd ${REMOTE_DIR}; ./app-start.bash"
