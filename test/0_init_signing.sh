#!/bin/bash
mkdir -p ~/.gnupg/
chmod 700 ~/.gnupg/

cp -r /etc/rpm_s3/test/.gnupg/* ~/.gnupg
chmod 600 ~/.gnupg/*

cp /etc/rpm_s3/test/.rpmmacros ~

cat <<EOF >~/.gnupg/gpg-agent.conf
default-cache-ttl 46000
allow-preset-passphrase
EOF

export SIGNING_PRIVATE_PASSPHRASE=${SIGNING_PRIVATE_PASSPHRASE:-}
# gpg2 --list-secret-keys --with-fingerprint   --with-keygrip
export KEYGRIP=C2B36F909BB6A3FF7FBC58EB078C665FF047AE5D

echo  "Reloading gpg-agent..."

export GPPPATH=/usr/libexec

python -mplatform | grep -qi centos && pkill -9 gpg-agent || true

#python -mplatform | grep -qi centos && source <(gpg-agent --daemon)
python -mplatform | grep -qi centos && gpg-connect-agent RELOADAGENT /bye || true

python -mplatform | grep -qi debian && gpg-connect-agent RELOADAGENT /bye

python -mplatform | grep -qi debian && export GPPPATH=/usr/lib/gnupg2

python -mplatform | grep -qi Ubuntu && gpg-connect-agent RELOADAGENT /bye

python -mplatform | grep -qi Ubuntu && export GPPPATH=/usr/lib/gnupg2


#echo "$SIGNING_PUBLIC_KEY" | gpg --import
#echo "$SIGNING_PRIVATE_KEY" > gpg_private.key
#echo "$SIGNING_PRIVATE_PASSPHRASE" | gpg --batch --yes --passphrase-fd 0 --import gpg_private.key
#echo "$SIGNING_KEY_ID"

if [ ! -z "$SIGNING_PRIVATE_PASSPHRASE" ]
then
  echo  "Presetting signing password..."
  echo $SIGNING_PRIVATE_PASSPHRASE | $GPPPATH/gpg-preset-passphrase -v -c $KEYGRIP
fi

