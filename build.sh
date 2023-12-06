#!/bin/bash

BUILD=build
SSD=${BUILD}/HCR.ssd
BIN=${BUILD}/HCR
LOG=${BUILD}/HCR.log

mkdir -p ${BUILD}

beebasm -i firmware/hcr.asm -v -o ${BIN} > ${LOG}

rm -f ${SSD}
beeb blank_ssd ${SSD}
beeb title ${SSD} "HCR Micron+"
beeb putfile ${SSD} ${BIN}
beeb info ${SSD}
