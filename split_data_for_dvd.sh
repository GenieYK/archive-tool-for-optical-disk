#!/bin/sh

if [ -L $0 ]; then
    MAKEARCHIVE_ROOT=$(dirname $(readlink $0))
else
    MAKEARCHIVE_ROOT=$(cd $(dirname $0); pwd)
fi

export MAKEARCHIVE_ROOT

rm -rf $MAKEARCHIVE_ROOT/chunks
mkdir $MAKEARCHIVE_ROOT/chunks

(cd $MAKEARCHIVE_ROOT/chunks && split -b 256m)

rm -rf $MAKEARCHIVE_ROOT/dvd-files
mkdir $MAKEARCHIVE_ROOT/dvd-files

DISK_NUMBER=1

MOVE_TO=$MAKEARCHIVE_ROOT/dvd-files/DISK$(printf '%02d' $DISK_NUMBER)
mkdir $MOVE_TO

for FRAGMENT in $(ls $MAKEARCHIVE_ROOT/chunks); do

    if [ $(ls $MOVE_TO | wc -l) -ge 16 ]; then
        DISK_NUMBER=$(echo $DISK_NUMBER + 1 | bc)
        MOVE_TO=$MAKEARCHIVE_ROOT/dvd-files/DISK$(printf '%02d' $DISK_NUMBER)
        mkdir $MOVE_TO
    fi

    mv $MAKEARCHIVE_ROOT/chunks/$FRAGMENT $MOVE_TO

done

rmdir $MAKEARCHIVE_ROOT/chunks
