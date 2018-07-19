#!/usr/bin/env bash

# trace ERR through pipes
set -o pipefail

# trace ERR through 'time command' and other functions
set -o errtrace

# set -u : exit the script if you try to use an uninitialised variable
set -o nounset

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

APPLICATION_USER_NAME=${APPLICATION_USER_NAME:-}
APPLICATION_GROUP_NAME=${APPLICATION_GROUP_NAME:-}
APPLICATION_CACHE=${APPLICATION_CACHE:-}
APPLICATION_LOGS=${APPLICATION_LOGS:-}
APPLICATION_UPLOADS=${APPLICATION_UPLOADS:-}

if [ x"$APPLICATION_USER_NAME" != x ]; then
	owner="$APPLICATION_USER_NAME"
	if [ x"$APPLICATION_GROUP_NAME" != x ]; then
		owner="${owner}:$APPLICATION_GROUP_NAME"
	fi

	if [ x"$APPLICATION_CACHE" != x ] && [ -d "$APPLICATION_CACHE" ]; then
		chown -R ${owner} ${APPLICATION_CACHE}
	fi

	if [ x"$APPLICATION_LOGS" != x ] && [ -d "$APPLICATION_LOGS" ]; then
		chown -R ${owner} ${APPLICATION_LOGS}
	fi

	if [ x"$APPLICATION_UPLOADS" != x ] && [ -d "$APPLICATION_UPLOADS" ]; then
		chown -R ${owner} ${APPLICATION_UPLOADS}
	fi
fi