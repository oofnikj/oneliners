#!/usr/bin/env bash
############## sops secret batch processor ###############
# Use this script to batch encrypt / decret secrets.     #
# with sops: https://github.com/mozilla/sops             #
##########################################################
set -e

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
REPO_DIR=$(git rev-parse --show-toplevel)
ENCRYPTED_DIR=${ENCRYPTED_DIR:-sops}
PLAINTEXT_DIR=${PLAINTEXT_DIR:-secrets}

XARGS=$(which xargs)
todo=$(mktemp)


encrypt() {
	plaintext_files=$(find ${REPO_DIR} -type f -regex ".*${PLAINTEXT_DIR}/.*" -exec realpath {} \;)
	for src in ${plaintext_files}; do
		dest=$(printf ${src} | sed "s%${PLAINTEXT_DIR}%${ENCRYPTED_DIR}%")
		mkdir -p $(dirname ${dest})
		printf "sops --encrypt --verbose ${src} > ${dest}\0" >> ${todo}
	done
	$XARGS -P10 -n1 -0 -I% -a ${todo} sh -c '%'
}

decrypt() {
	encrypted_files=$(find ${REPO_DIR} -type f -regex ".*${ENCRYPTED_DIR}/.*")
	for src in ${encrypted_files}; do
		dest=$(printf ${src} | sed "s%${ENCRYPTED_DIR}%${PLAINTEXT_DIR}%")
		mkdir -p $(dirname ${dest})
		printf "sops --decrypt --verbose ${src} > ${dest}\0" >> ${todo}
	done
	$XARGS -P10 -n1 -0 -I% -a ${todo} sh -c '%'
}

cleanup() {
	rm ${todo}
}

trap cleanup EXIT

if [[ $(uname) == 'Darwin' ]] ; then
	XARGS=$(which gxargs) || { echo "This script reqires GNU xargs and coreutils. Install with 'brew install findutils coreutils'"; exit 1; }
fi

case $1 in
	encrypt)
		encrypt
	;;
	decrypt)
		decrypt
	;;
	*)
		echo "$0 [encrypt | decrypt]"
		exit 1
	;;
esac
