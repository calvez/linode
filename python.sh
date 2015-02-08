#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#
# @PYTHON - python packages
# - get pip
# - get PRAW

# @PYTHON
function get_pip {
    apt-get update
    apt-get install python-pip -y
}

function get_praw {
    pip install praw
}
