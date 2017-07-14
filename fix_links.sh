#!/bin/bash

BASEDIR=$1

if [ ! -d "${BASEDIR}" ]; then
  echo "Usage: $0 DIRECTORY" 1>&2
  exit 1
fi

function is_absolute_path() {
  echo $1 | grep '^/' > /dev/null 2>&1
  return $?
}

OFS=$IFS
IFS=$'\n'

for link in $(find ${BASEDIR} -type l); do
  linkloc=$(readlink $link)
  is_absolute_path $linkloc

  if [ "$?" -ne "0" ]; then
    linkloc="${BASEDIR}/$linkloc"
  fi

  cp -v --remove-destination $linkloc $link
done