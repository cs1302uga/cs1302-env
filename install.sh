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
    darwin)
	declare -r CS1302_ENV_OS="macos"
	;;
    linux)
	declare -r CS1302_ENV_OS="linux"
	;;
    cygwin*)
	declare -r CS1302_ENV_OS="cygwin"
	;;
    *)
	declare -r CS1302_ENV_OS="unknown"
	;;
esac

for VAR in "${!CS1302_ENV_@}"; do
    if [[ ! -z "${!VAR:-}" ]]; then
	echo "${VAR}=${!VAR}"
    fi
done

cs1302_env_url() {
    printf 'https://raw.githubusercontent.com/cs1302uga/cs1302-env/main/%s\n' "${1}"
} # cs1302_env_url
