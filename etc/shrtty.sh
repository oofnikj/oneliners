#!/bin/sh
###           shrtty            ###
#   a simple script to share a    #
#   terminal session over TCP     #
###                             ###
set -e

PORT=${1:-9119}

shrtty() {
  fifo=$(mktemp -u)
  mkfifo $fifo
  if [[ $(uname) == "Darwin" ]]; then
    NC_ARGS="-kl"
    SCRIPT_ARGS="-qF"
  else :
    NC_ARGS="-kl -p"
    SCRIPT_ARGS="-qf"
  fi
  nc $NC_ARGS $PORT <$fifo >/dev/null &
  printf "listening on :$PORT\n"
  printf "connect with 'nc $(hostname) $PORT'\n"
  printf "press ^D to exit\n"
  script $SCRIPT_ARGS $fifo
}

cleanup() {
  kill %1
  rm $fifo
}

trap cleanup EXIT
shrtty
