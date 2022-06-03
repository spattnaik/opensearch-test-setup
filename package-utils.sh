#! /bin/bash

function install_yarn {
  curl -o- -L https://yarnpkg.com/install.sh | bash
}

function install_nvm {
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  source ~/.bashrc
}

function install_nodejs_with_nvm {
  node_version=$1
  
}

function get_java_version {
  if type -p java; then
    _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    _java="$JAVA_HOME/bin/java"
  fi

  if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo version
  else
    echo "-"
  fi
}

function is_required_java_version_installed {
  # first check if the package is installed or not
  java_installed=$(sudo yum list installed | grep $1 | wc -l)
  echo $java_installed
}

function set_required_java_version {
  java_path=$(alternatives --list | grep $1 | grep javac | awk -F ' ' '{print $3}')
  sudo alternatives --set java ${java_path%?} # Remove last character from javac
  sudo alternatives --set javac $java_path
}
