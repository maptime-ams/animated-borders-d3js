#!/bin/bash

SHAPEFILES=../data/*.zip
for f in $SHAPEFILES
do
  year=$(printf ${f} | sed "s/^.*_\(.*\).zip$/\1/")
  echo Parsing shapefile ${year}...
  shp2json $f | topojson -p STATENAM -s 1e-6 -o ../data/$year.json
done
