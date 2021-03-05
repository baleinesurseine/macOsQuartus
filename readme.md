# Run Quartus II on macOS

## Intro

Quartus II from Intel/Altera can be installed on Windows and Linux only.

The solution is to install and run Quartus on a Linux distribution running in a docker container. The X11 graphical interface is channeled to the macOS and viewed with XQuartz.

## macOS setup

* Install and run [XQuartz](https://www.xquartz.org "XQuartz")
* In preferences/security, allow connections from network clients
* run `xhost + localhost` in a shell terminal

## build docker image

* You must have downloaded the installation file from altera in the folder where dockerfile resides. (this is a HUGE file, more than 2G). The link is : <https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/QuartusLiteSetup-20.1.1.720-linux.run>
* You must also download the files for your specific FPGA, e.g. : <https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/cyclone10lp-20.1.1.720.qdz>
* In a shell terminal, run `docker build -t quartus .`
* NB: don't forget the ending dot !

The resulting docker image will have a size ~10G

## run Quartus

Run this shell command: `docker run --rm -d -e DISPLAY=host.docker.internal:0 --net=host --volume=/shared/folder:/macOS/shared/folder quartus`
