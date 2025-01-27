#!/bin/bash

# Note: this script MUST be self-contained - i.e. it MUST NOT source any
# external scripts as it is used as a bootstrap script, thus it's
# fetched and executed without rest of this repository
#
# Example usage in Jenkins
# #!/bin/sh
#
# set -e
#
# curl -q -o runner.sh https://../rhel9-centos9-sanitizers.sh
# chmod +x runner.sh
# ./runner.sh
set -eu
set -o pipefail

ARGS=()

if [[ -v ghprbPullId && -n "$ghprbPullId" ]]; then
    ARGS+=(--pr "$ghprbPullId")
fi

git clone https://github.com/systemd/systemd-centos-ci
cd systemd-centos-ci

./agent-control.py --pool metal-seamicro-large-centos-9s-x86_64 \
                   --bootstrap-script="bootstrap-rhel9.sh" \
                   --bootstrap-args="-h unified -z" \
                   --testsuite-script="testsuite-rhel9-sanitizers.sh" \
                   --skip-reboot \
                   ${ARGS:+"${ARGS[@]}"}
