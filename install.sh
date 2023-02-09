#!/bin/bash

cd `dirname $0`
DATE=`date +"%Y-%m-%d-%H%M%S%Z"`
LOGDIR=./log

function gnome_update() {
    dconf load / < gnome-settings.ini
}

function main() {
    gnome_update
}

main