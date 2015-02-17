#!/bin/bash

echo "Grouping all TopoJSON files into one"
cat ../data/[0-9]*.json | json -g -0 > ../data/states.json
echo "Done..."
