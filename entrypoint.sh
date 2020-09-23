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
  if [ -z "${INPUT_DEPS}" ] || [ "${INPUT_DEPS}" = "false" ]; then
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
  if [ "${INPUT_PYTEST_DIR}" = "" ]; then
    echo "PyTest directory/file not provided, skipping test run"
  else
    echo "PyTest running a directory/file: ${INPUT_PYTEST_DIR}"
    if [ "${INPUT_PYTEST_ARGS}" = "" ]; then
      echo "Running PyTest without any custom arguments"
      sh -c "pytest ${INPUT_PYTEST_DIR}"
    else
      echo "Running PyTest with custom arguments: ${INPUT_PYTEST_ARGS}"
      sh -c "pytest ${INPUT_PYTEST_DIR} ${INPUT_PYTEST_ARGS}"
    fi
  fi
}

main() {
  echo "Starting.........."
  installProjectDependencies
  echo "Dependencies installed"
  runTests
  echo "..........Completed"
}

main
