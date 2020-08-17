#!/bin/bash
###           shrtty            ###
#   a simple script to share a    #
#   terminal session over TCP     #
###                             ###
set -e

PORT=${1:-9119}

shrtty() {
  fifo=$(mktemp -u)
  mkfifo $fifo
  nc -kl $PORT <$fifo >/dev/null &
  printf "listening on :$PORT\n"
  printf "connect with 'nc $(hostname) $PORT'\n"
  printf "press ^D to exit\n"
  PS1='(tc) $PS1'
  if [[ $(uname) == "Darwin" ]]; then
    script -qF $fifo
  else
    script -qf $fifo
  fi
}

cleanup() {
  kill %1
  rm $fifo
}

trap cleanup EXIT
shrtty
