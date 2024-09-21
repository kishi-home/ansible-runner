#!/bin/bash

if [ -z "${TOKEN}" ]; then
  echo "TOKEN must be set" 1>&2
  exit 1
fi

if [ -z "${ORGANIZATION}" ]; then
  echo "ORGANIZATION must be set" 1>&2
  exit 1
fi

if [ -z "${SSHKEY}" ]; then
  echo "SSHKEY must be set" 1>&2
  exit 1
fi

echo $SSHKEY | sed -z 's/\\n/\n/g' > /ansible-runner/id_ed25519 && \
chmod 600 /ansible-runner/id_ed25519

./config.sh remove
./config.sh \
    --unattended \
    --url $HOST/$ORGANIZATION \
    --token $TOKEN \
    --name $RUNNER_NAME \
    --runnergroup $RUNNER_GROUP \
    --labels $RUNNER_LABELS \
    --work $RUNNER_WORKDIR

./run.sh
