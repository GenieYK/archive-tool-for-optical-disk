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

rm -rf $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd
mkdir $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd

(cd $TAR_BASE_DIR && tar czf - $TAR_TARGETS | openssl enc -e -aes256 -k $PASSWORD) | (cd $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd && split -b 256m)

rm -rf $MAKEARCHIVE_ROOT/result_dvd
mkdir $MAKEARCHIVE_ROOT/result_dvd

DISK_NUMBER=1

MOVE_TO=$MAKEARCHIVE_ROOT/result_dvd/DISK$(printf '%02d' $DISK_NUMBER)
mkdir $MOVE_TO

for CHUNK in $(ls $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd); do

    if [ $(ls $MOVE_TO | wc -l) -ge 16 ]; then
        DISK_NUMBER=$(echo $DISK_NUMBER + 1 | bc)
        MOVE_TO=$MAKEARCHIVE_ROOT/result_dvd/DISK$(printf '%02d' $DISK_NUMBER)
        mkdir $MOVE_TO
    fi

    mv $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd/$CHUNK $MOVE_TO

done

rmdir $MAKEARCHIVE_ROOT/tmp_make_archive_for_dvd
