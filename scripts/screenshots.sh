#!/bin/bash

# To run this script, first install webkit2png
# and start a webserver in the tutorial's root:
#   python -m SimpleHTTPServer

cd ..

STEPS=tutorial/*
for s in $STEPS
do
  echo Tutorial step: $s
  webkit2png --delay=3 -W 1024 -H 786 -F -o $s http://localhost:8000/$s
done
