#!/bin/bash

diff ../tutorial/$(expr $1 - 1)/index.html ../tutorial/$1/index.html
