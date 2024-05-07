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
case "${CS1302_ENV_MACHINE}" in
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

declare -r CS1302_ENV_HOME="${HOME}/.cs1302-env"

declare -r CS1302_ENV_JDK_VERSION="${1:-17.0.10}"
declare -r CS1302_ENV_JDK_HOME="${CS1302_ENV_HOME}/jdk"

declare -r CS1302_ENV_MVN_VERSION="${1:-3.9.6}"
declare -r CS1302_ENV_MVN_HOME="${CS1302_ENV_HOME}/mvn"

function jdk_url() {
    local VERSION_MAJOR="$(echo "${CS1302_ENV_JDK_VERSION}"| cut -d. -f1)"
    local ARCHIVE="jdk-${VERSION}_${CS1302_ENV_JDK}_bin.tar.gz"
    printf 'https://download.oracle.com/java/%s/archive/%s\n' \
	   "${VERSION_MAJOR}" \
	   "${ARCHIVE}"
} # jdk_url

function mvn_url() {
    local VERSION_MAJOR="$(echo "${CS1302_ENV_MVN_VERSION}"| cut -d. -f1)"
    local ARCHIVE="apache-maven-${VERSION}-bin.tar.gz"
    printf 'https://dlcdn.apache.org/maven/maven-%s/%s/binaries/%s\n' \
	   "${VERSION_MAJOR}" \
	   "${VERSION}" \
	   "${ARCHIVE}"
} # mvn_url

function jdk_install() {
    (
	set -x
	mkdir -p "${CS1302_ENV_JDK_HOME}"
	pushd "${CS1302_ENV_HOME}"
	curl --progress-bar -o "jdk.tar.gz" "$(jdk_url)"
	tar -z -x --strip-components 4 --cd "${CS1302_ENV_JDK_HOME}" -f "jdk.tar.gz"
	popd
    )
} # jdk_install

echo "Installing JDK..."
jdk_install

echo "Installing MVN..."
echo "$(mvn_url)"
