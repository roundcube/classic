#!/bin/sh

set -e

PWD=`dirname "$0"`

$PWD/jsshrink.sh && $PWD/cssshrink.sh && $PWD/cssimages.sh
