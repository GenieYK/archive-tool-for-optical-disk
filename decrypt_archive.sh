#!/bin/sh

if [ -L $0 ]; then
    MAKEARCHIVE_ROOT=$(dirname $(readlink $0))
else
    MAKEARCHIVE_ROOT=$(cd $(dirname $0); pwd)
fi

export MAKEARCHIVE_ROOT

CONFIG_FILE=$1

[ -e $MAKEARCHIVE_ROOT/$CONFIG_FILE ] && . $MAKEARCHIVE_ROOT/$CONFIG_FILE

[ -z "$PASSWORD" ] && exit 200
export PASSWORD

openssl enc -d -aes256 -k $PASSWORD
