#!/bin/sh

set -e
set -u

installDependenciesFromFile(){
  echo "Installing $1"
  pip install -r "$1"
  if ! pip install -r "$1"; then
    echo "Failed to install $1"
  else
    echo "Successfully installed $1"
  fi
}

installProjectDependencies() {
  if [ "${INPUT_DEPS}" = "false" ]; then
    if [ -e "requirements.txt" ]; then
      echo "Found default requirements.txt, installing"
      installDependenciesFromFile "requirements.txt"
    else
      echo "No requirements to install, skipping..."
		fi
  else
    echo "Installing requirements from: ${INPUT_DEPS}"
    IFS=','
    for requirements_file in ${INPUT_DEPS}
    do
      installDependenciesFromFile "${requirements_file}"
    done
  fi
}

runTests() {
  sh -c "pytest ${INPUT_PYTEST_DIR} ${INPUT_PYTEST_ARGS}"
}

main() {
  echo "Starting.........."
  installProjectDependencies
  runTests
  echo "..........Completed"
}

main
