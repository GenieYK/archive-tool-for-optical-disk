#!/bin/sh

if [ -L $0 ]; then
    MAKEARCHIVE_ROOT=$(dirname $(readlink $0))
else
    MAKEARCHIVE_ROOT=$(cd $(dirname $0); pwd)
fi

export MAKEARCHIVE_ROOT

CONFIG_FILE=$1

[ -e $MAKEARCHIVE_ROOT/$CONFIG_FILE ] && . $MAKEARCHIVE_ROOT/$CONFIG_FILE

[ -z "$TAR_BASE_DIR" ] && exit 200
export TAR_BASE_DIR

[ -z "$TAR_TARGETS" ] && exit 200
export TAR_TARGETS

[ -z "$PASSWORD" ] && exit 200
export PASSWORD

rm -rf $MAKEARCHIVE_ROOT/result
mkdir $MAKEARCHIVE_ROOT/result

(cd $TAR_BASE_DIR && tar czf - $TAR_TARGETS | openssl enc -e -aes256 -k $PASSWORD) | (cd $MAKEARCHIVE_ROOT/result && split -b 256m)
