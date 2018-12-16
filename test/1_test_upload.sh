#!/bin/sh
export PATH=/etc/rpm_s3/:$PATH


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

echo -e "  ${bold}${yellow}uploading ${cyan}test/blank-noop-app-1.0.0-20141120070739.x86_64.rpm${yellow} to bucket ${cyan}pkgr-development-rpm${yellow} codename ${cyan}test${normal}"
echo rpm-s3 -b pkgr-development-rpm -p test --visibility implied --s3_endpoint_url http://minio1:9000 --s3_signature_version s3v4 test/blank-noop-app-1.0.0-20141120070739.x86_64.rpm
rpm-s3 -b pkgr-development-rpm -p test --visibility implied --s3_endpoint_url http://minio1:9000 --s3_signature_version s3v4 test/blank-noop-app-1.0.0-20141120070739.x86_64.rpm
echo -e "  ${bold}${yellow}validating s3 s3://pkgr-development-rpm/test/${normal}"
aws --endpoint-url http://minio1:9000/ s3 ls s3://pkgr-development-rpm/test/
