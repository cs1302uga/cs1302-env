#!/bin/bash

#------------------------------------------------------------------------------#

set -p # privileged mode
set -u # error on unset variable or parameter access

if [ -z "${BASH_VERSION:-}" ]; then
    echo "Error: Bash is required to run $0." 1>&2
    exit 1
fi

set +o posix # turn off POSIX mode

#------------------------------------------------------------------------------#

declare -r CS1302_ENV_OSTYPE="$(uname -s | tr '[A-Z]' '[a-z]')"
case "${CS1302_ENV_OSTYPE}" in
    darwin*)
	declare -r CS1302_ENV_OS="macos"
	;;
    *)
	echo "Error: Unable to continue. This is the 'macos' installer, but" \
	     "'${CS1302_ENV_OSTYPE}' was detected instead." \
	     1>&2
	exit 1
	;;
esac

echo "Running the 'macos' installer..."
echo ""

declare -r CS1302_ENV_MACHINE="$(uname -m | tr '[A-Z]' '[a-z]')"
case "${CS1302_ENV_OSTYPE}" in
    arm64)
	declare -r CS1302_ENV_JDK="macos-aarch64"
	;;
    x86_64)
	declare -r CS1302_ENV_JDK="macos-x64"
	;;
    *)
	echo "Error: Unable to continue. The 'macos' installer is not able to" \
	     "determine the machine type (expected 'arm64' or 'x86_64', but" \
	     "'${CS1302_ENV_MACHINE}' was detected instead)." \
	     1>&2
	exit 1
	;;
esac
