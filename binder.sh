#!/bin/bash

whoami
pwd
ls /home


supervisord -n &

echo "Running TangoDB"

sleep 10

$HOME/anaconda3/bin/conda run -n sardana-jupyter --no-capture-output Sardana demo &

echo "Running Sardana"
