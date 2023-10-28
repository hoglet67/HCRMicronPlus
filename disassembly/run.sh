#!/bin/bash

export PYTHONPATH=../../py8dis/py8dis

python HCR141.py > HCR141.asm
beebasm -i HCR141.asm -o HCR141.bin
md5sum HCR141.orig HCR141.bin
