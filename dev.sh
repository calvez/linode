#!/bin/bash
#
# @author jbaranski - https://github.com/jbaranski/linode
#
# @DEV - development / production tools...
# - get docker
# - get java 8
# - get ruby
# - get sencha cmd

# @DEV
function get_docker {
    curl -sSL https://get.docker.com/ubuntu/ | sudo sh
}

function get_java8 {
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
    add-apt-repository -y ppa:webupd8team/java
    apt-get update
    apt-get install -y oracle-java8-installer
    rm -rf /var/lib/apt/lists/*
    rm -rf /var/cache/oracle-jdk8-installer
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle
}

function get_ruby {
    apt-get update
    apt-get install -y ruby
    rm -rf /var/lib/apt/lists/*
}

function get_senchacmd {
    curl -O http://cdn.sencha.com/cmd/5.1.1.39/SenchaCmd-5.1.1.39-linux-x64.run.zip
    unzip SenchaCmd-5.1.1.39-linux-x64.run.zip
    chmod +x SenchaCmd-5.1.1.39-linux-x64.run
    ./SenchaCmd-5.1.1.39-linux-x64.run --mode unattended --prefix /home
    PATH=$PATH:/home/Sencha/Cmd/5.1.1.39
    rm -f SenchaCmd-5.1.1.39-linux-x64.run
    rm -f SenchaCmd-5.1.1.39-linux-x64.run.zip
}
