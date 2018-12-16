#!/bin/sh
set -xe

pip install -r requirements.txt
pip install awscli
aws configure set default.s3.signature_version s3v4
