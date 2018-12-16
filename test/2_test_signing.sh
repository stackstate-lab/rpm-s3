#!/bin/bash

set -e

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

export SIGNING_PRIVATE_PASSPHRASE=${SIGNING_PRIVATE_PASSPHRASE:-}

export RPMS3_EXTRA_PARAMS=${RPMS3_EXTRA_PARAMS:-}

if [ -z "$SIGNING_PRIVATE_PASSPHRASE" ]
then
  export RPMS3_EXTRA_PARAMS="--expect $RPMS3_EXTRA_PARAMS"
fi

cd /etc/rpm_s3

echo "${yellow} Validating signing + upload ${yellow}"

./rpm-s3 -b pkgr-development-rpm -p test2 --sign --expect --visibility implied --s3_endpoint_url http://minio1:9000 --s3_signature_version s3v4 test/blank-noop-app-1.0.0-20141120070739.x86_64.rpm

echo "${yellow} Validating signing ${yellow}"

# Export your public key from your key ring to a text file.
gpg --export -a 'rpm-s3' > ~/RPM-GPG-KEY

# Import your public key to your RPM DB
rpm --import ~/RPM-GPG-KEY

# Verify the list of gpg public keys in RPM DB
rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

rpm --checksig test/*.rpm

echo -e "  ${bold}${yellow}validating s3 s3://pkgr-development-rpm/test2/${normal}"
aws --endpoint-url http://minio1:9000/ s3 ls s3://pkgr-development-rpm/test2/
