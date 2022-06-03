#!/bin/bash

source $(dirname $0)/utils.sh
source $(dirname $0)/package-utils.sh

package_manager=$(get_package_manager)
current_user=$(id -un)
current_user_group=$(id -gn)
opensearch_base_dir="/opensearch"
opensearch_github="https://github.com/opensearch-project/OpenSearch.git"
opensearch_dashboard_github="https://github.com/opensearch-project/OpenSearch.git"
opensearch_code_dir=OpenSearch
opensearch_dashboard_code_dir=opensearch_dashboard
required_java_version=java-11-openjdk
set_java_path_later=0

package_list="curl wget git"

java=$(get_java_version)
if [ ${java:0:2} != "11" ]; then
  # Check if the version is already installed but not set in path
  is_installed=$(is_required_java_version_installed $required_java_version)
  if [ $is_installed > 0 ]; then
    set_required_java_version $required_java_version
  else
    package_list="${package_list} ${required_java_version}-devel"
    set_java_path_later=1
  fi
fi

sudo $package_manager -y update
sudo $package_manager install -y $package_list
if [ $set_java_path_later == 1 ]; then
  set_required_java_version $required_java_version
fi

echo "<== Setting up OpenSearch first ==>"

# Create the opensearch directory first
if [ ! -d "$opensearch_base_dir" ]; then
  sudo mkdir -p $opensearch_base_dir

  sudo chown $current_user:$current_user_group $opensearch_base_dir
fi
cd $opensearch_base_dir

if [ -d "$opensearch_code_dir" ] 
then
  cd $opensearch_code_dir
  current_git_branch="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$current_git_branch" != "main" ]]
  then
    git checkout main
    if [ $? -eq 0 ]
    then
      git pull origin main
    else
      echo "Some error in switching to main branch. Resolve the conflict and try again"
      exit 1
    fi
  else
    git pull origin main
  fi
else
  git clone $opensearch_github
  cd $opensearch_code_dir
fi

echo "<== Build OpenSearch ==>"
./gradlew localDistro
