#!/bin/bash

#------------------------------------------------------------------------------#

set -p # privileged mode
set -u # error on unset variable or parameter access

if [ -z "${BASH_VERSION:-}" ]; then
    echo "Error: Bash is required to run $0." 1>&2
    exit 1
fi

set +o posix # turn off POSIX mode

shopt -s checkwinsize

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

fetch() {
    local URL="${1}"
    local TIMESTAMP="$(date +%s)"
    curl -fsSL "${URL}?token=${TIMESTAMP}" \
	 -X GET \
	 -H 'Cache-Control: no-cache, no-store, must-revalidate' \
	 -H 'Pragma: no-cache' \
	 -H 'Expires: 0'
} # fetch

fetch_and_run_installer() {
    local OS="${1}"
    local INSTALLER="install-${OS}.sh"
    local URL="https://raw.githubusercontent.com/cs1302uga/cs1302-env/main/${INSTALLER}"
    if curl -fsSL -I ${URL} >/dev/null 2>&1; then
	COLUMNS="${COLUMNS:-80}" \
	       bash -c "$(fetch ${URL})"
    else
	echo "Error: Unable to continue. Unable to fetch the installer for" \
	     "the '${OS}' operating system." \
	     1>&2
	exit 1
    fi
} # fetch_and_run_installer

for VAR in "${!CS1302_ENV_@}"; do
    if [[ ! -z "${!VAR:-}" ]]; then
	echo "${VAR}=${!VAR}"
    fi
done

cat <<-EOF
         _______ ___  ___
 _______<  /_  // _ \|_  |
/ __(_-</ //_ </ // / __/
\__/___/_/____/\___/____/

EOF

fetch_and_run_installer "${CS1302_ENV_OS}"
