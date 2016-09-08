#!/bin/sh

. resources/colors.sh

verbose "package-all.sh..."

#initialize variable encase we are called directly
[ -z $USE_SWITCH_PACKAGE_UNOFFICIAL_ARM ] && USE_SWITCH_PACKAGE_UNOFFICIAL_ARM=false
