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
    cygwin*)
	declare -r CS1302_ENV_OS="cygwin"
	;;
    *)
	echo "Error: Unable to continue. This is the 'cygwin' installer, but" \
	     "'${CS1302_ENV_OSTYPE}' detected instead." \
	     1>&2
	exit 1
	;;
esac

echo "Running the 'cygwin' installer..."
echo ""

if type -P MobApt >/dev/null 2>&1; then
    declare -r APT="$(type -P MobApt)"
fi

2>&1 COLUMNS="$((${COLUMNS}-10))" \
     "${APT}" install -y \
     automake make gcc-core gcc-g++ libgccjit0 patch bzip2 perl tar xz \
     coreutils curl cygutils git ncurses unzip wget \
     libjansson-devel libjansson-doc libjansson4 \
     zlib zlib0 zlib-devl \
    | sed 's|^|[apt-get] |g'
