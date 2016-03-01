#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#
# @CORE - core development and production tools...
# @PYTHON - python specific tools and packages...

# @CORE
function get_docker {
    curl -sSL https://get.docker.com/ | sudo sh
}

function get_git {
    apt-get update
    apt-get install -y git
}
