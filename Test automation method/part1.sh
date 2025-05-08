#!/bin/bash

sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

 docker run -d --name onos \
 -p 8181:8181 -p 6653:6653 -p 8101:8101 \
 onosproject/onos


