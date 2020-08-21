#!/bin/sh
set -xe

export PIPBINARY=${PIPBINARY:-pip}

$PIPBINARY install -r requirements.txt
$PIPBINARY install awscli
aws configure set default.s3.signature_version s3v4
