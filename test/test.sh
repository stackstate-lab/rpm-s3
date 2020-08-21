#!/bin/bash

set -e

DIR=$( cd "$( dirname "$0" )" && pwd )
ROOT_DIR="$(dirname "$DIR")"
TMPDIR=$(mktemp -d)
SIGNING_PRIVATE_PASSPHRASE=

cp -r ${DIR}/.gnupg $TMPDIR/
chmod 0700 $TMPDIR/.gnupg
cp ${DIR}/.rpmmacros $TMPDIR/

# used to get .rpmmacros and .gnupg
HOME="$TMPDIR"
echo "HOME=$HOME"

cat <<EOF >~/.gnupg/gpg-agent.conf
default-cache-ttl 46000
allow-preset-passphrase
EOF


gpg-connect-agent RELOADAGENT /bye
# If you get error message `gpg-connect-agent: can't connect to the agent: IPC connect call failed` , most likely
# you will need to use more dirty way (usually centos):

#pkill -9 gpg-agent
#source <(gpg-agent --daemon)

export PYTHONBINARY=${PYTHONBINARY:-python}

echo $SIGNING_PRIVATE_PASSPHRASE | /usr/lib/gnupg2/gpg-preset-passphrase -v -c $(gpg --list-secret-keys --with-fingerprint --with-colons | awk -F: '$1 == "grp" { print $10 }')

$PYTHONBINARY $ROOT_DIR/rpm-s3 -b ${BUCKET:="pkgr-development-rpm"} -v -p gh/crohr/test/centos6/master --sign --keep 1000 ${DIR}/*.rpm

echo "DONE"
