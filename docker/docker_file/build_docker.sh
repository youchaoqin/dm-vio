#!/usr/bin/bash

set -e

BASH_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ALL_PACKAGES_DIR="${BASH_FILE_DIR}/packages"

function copy_package() {
  local COPY_SRC_PACKAGE=$1
  local COPY_DST_FOLDER=$2  

  if [ ! -d $COPY_DST_FOLDER ]; then
    echo "folder not exist: ${COPY_DST_FOLDER}"
    exit 0
  fi

  if [ ! -f $COPY_SRC_PACKAGE ]; then
    echo "package not exist: ${COPY_SRC_PACKAGE}"
    exit 0
  fi

  cp $COPY_SRC_PACKAGE $COPY_DST_FOLDER
}

function build_image_x86() {
  local ARCH=$(uname -m)
  if [ ! ${ARCH} = "x86_64" ]; then
    echo "not on a x86_64 machine, stop."
    exit 0
  fi
  local X86_BASE_FOLDER="${BASH_FILE_DIR}/x86"
  local X86_PKG_FOLDER="${X86_BASE_FOLDER}/packages"
  if [ -d $X86_PKG_FOLDER ]; then
    rm -r $X86_PKG_FOLDER
  fi
  mkdir -p $X86_PKG_FOLDER
  
  #copy packages to be built from source
  copy_package "${ALL_PACKAGES_DIR}/gtsam-4.2a6.zip" $X86_PKG_FOLDER
  copy_package "${ALL_PACKAGES_DIR}/Pangolin-0.6.tar.gz" $X86_PKG_FOLDER

  #generate tag
  local CURR_TIME=`date '+%Y-%m-%d_%H-%M-%S'`
  local X86_TAG="dm_vio_devel_x86:${CURR_TIME}"
  
  cd $X86_BASE_FOLDER
  docker build -t ${X86_TAG} .

  if [ -d $X86_PKG_FOLDER ]; then
    rm -r $X86_PKG_FOLDER
  fi
}



function print_usage() {
  echo "### Usage: ###"
  echo "bash build_docker.sh build_x86     : build x86 docker image"
}

function main() {

  local CMD=$1
  if [ ! $CMD ]; then
    CMD="is_null"
  fi

  case $CMD in
    build_x86)
      build_image_x86
      ;;
    *)
      print_usage
      ;;
  esac
}

main $@