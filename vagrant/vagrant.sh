#!/bin/bash

VAGRANT_DEFAULT_PROVIDER=virtualbox
VAGRANT_BOX_NAME=centos/7

vagrant box add --provider $VAGRANT_DEFAULT_PROVIDER $VAGRANT_BOX_NAME
vagrant up
#vagrant destroy -f
#vagrant box remove $VAGRANT_BOX_NAME
