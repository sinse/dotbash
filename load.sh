#!/bin/env bash
BASH_DIR=~/.config/bash
ENABLED_SCRIPTS=$BASH_DIR/enabled
AVAILABLE_SCRIPTS=$BASH_DIR/available

# enable script
function bash-enable() {
    if [ -f $AVAILABLE_SCRIPTS/$1 ] ;
    then
        ln -s $AVAILABLE_SCRIPTS/$1 $ENABLED_SCRIPTS/$1
    fi
}

# disable script
function bash-disable() {
    if [ -f $ENABLED_SCRIPTS/$1 ] ;
    then
        rm -f $ENABLED_SCRIPTS/$1
    fi
}

# load environment
source $BASH_DIR/aliases
source /dev/stdin < <(find $ENABLED_SCRIPTS -xtype f ! -iname ".gitignore" -exec cat {} \;)

# extend PATH
export PATH=$PATH:$BASH_DIR/bin

