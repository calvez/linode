#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#

function get_docker {
    apt-get update
    apt-get install docker.io
}

function get_git {
    apt-get update
    apt-get install -y git
}
