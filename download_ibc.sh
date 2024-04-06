#!/bin/bash

git clone https://github.com/hunter89761/ibc-go.git
cd ibc-go

git checkout hunter-v6

docker build . -t webbshi/celestia-app:v1.6.0 -f Dockerfile1