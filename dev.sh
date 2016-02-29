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

function get_extjs {
    curl -O http://cdn.sencha.com/ext/gpl/ext-5.1.0-gpl.zip
    unzip ext-5.1.0-gpl.zip
    rm -rf ext-5.1.0-gpl.zip
}

function get_senchacmd {
    apt-get update
    apt-get install -y libfontconfig
    curl -O http://cdn.sencha.com/cmd/5.1.1.39/SenchaCmd-5.1.1.39-linux-x64.run.zip
    unzip SenchaCmd-5.1.1.39-linux-x64.run.zip
    chmod +x SenchaCmd-5.1.1.39-linux-x64.run
    ./SenchaCmd-5.1.1.39-linux-x64.run --mode unattended --prefix /home
    PATH=$PATH:/home/Sencha/Cmd/5.1.1.39
    rm -f SenchaCmd-5.1.1.39-linux-x64.run
    rm -f SenchaCmd-5.1.1.39-linux-x64.run.zip
}

function get_nginx {
    add-apt-repository -y ppa:nginx/stable
    apt-get update
    apt-get install -y nginx
    rm -rf /var/lib/apt/lists/*
    chown -R www-data:www-data /var/lib/nginx
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
    curl -O https://raw.githubusercontent.com/jbaranski/linode/master/nginx/nginx.conf
    curl -O https://raw.githubusercontent.com/jbaranski/linode/master/nginx/403.html
    curl -O https://raw.githubusercontent.com/jbaranski/linode/master/nginx/404.html
    curl -O https://raw.githubusercontent.com/jbaranski/linode/master/nginx/50x.html
    cp nginx.conf /etc/nginx/
    rm -f nginx.conf
    mkdir /var/www/html/errorpages
    cp 403.html /var/www/html/errorpages/
    cp 404.html /var/www/html/errorpages/
    cp 50x.html /var/www/html/errorpages/
    rm -f 403.html
    rm -f 404.html
    rm -f 50x.html
}

# @PYTHON
function get_pip {
    apt-get update
    apt-get install -y python-pip
}

function get_python_praw {
    pip install praw
}
