#!/bin/bash

TOKEN=$(curl -X PUT -s \
  http://169.254.169.254/latest/api/token \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PRIVATE_IP=$(curl -s \
  http://169.254.169.254/latest/meta-data/local-ipv4 \
  -H "X-aws-ec2-metadata-token: $TOKEN")

export MONGODB_URI="mongodb://${PRIVATE_IP}:27017/tictactoe"

exec npm start