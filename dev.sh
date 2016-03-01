#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#

function get_docker {
    curl -sSL https://get.docker.com/ | sudo sh
}

function get_git {
    apt-get update
    apt-get install -y git
}
