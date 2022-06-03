#!/bin/bash

function get_os_name {
  os_name=$(cat /etc/os-release | awk -F '=' '/^NAME/{print $2}' | awk '{print $1}' | tr -d '"')
  echo "$os_name"
}

function get_ubuntu_version {
  os_versionid=$(cat /etc/os-release | awk -F '=' '/^VERSION_ID/{print $2}' | awk '{print $1}' | tr -d '"')
  echo "$os_versionid"
}

function get_centos_version {
  os_versionid=$(cat /etc/os-release | awk -F '=' '/^VERSION_ID/{print $2}' | awk '{print $1}' | tr -d '"')
  echo "$os_versionid"
}

## Gets the version id as the only parameter
function get_ubuntu_package_manager_name {
  case $1 in
    "14.04" )
      echo "apt-get" ;;
    "16.04" )
      echo "apt-get" ;;
    "20.04" )
      echo "apt" ;;
  esac
}

function get_centos_package_manager_name {
  echo "yum"
}

function get_os_version {
  case $1 in
    "Ubuntu" )
      echo $(get_ubuntu_version) ;;
    "CentOS" )
      echo $(get_centos_version) ;;
  esac
}

function get_package_manager_name {
  case $1 in
    "Ubuntu" )
      echo $(get_ubuntu_package_manager_name $2) ;;
    "CentOS" )
      echo $(get_centos_package_manager_name $2) ;;
  esac
}


function get_package_manager {
  os=$(get_os_name)
  os_version=$(get_os_version $os)
  package_manager_name=$(get_package_manager_name $os $os_version)
  echo $package_manager_name
}

