# Run Quartus II on macOS

## Intro

Quartus II from Intel/Altera can be installed on Windows and Linux only.

The solution is to install and run Quartus on a Linux distribution running in a docker container. The X11 graphical interface is channeled to the macOS and viewed with XQuartz.

## macOS setup

* Install and run [XQuartz](https://www.xquartz.org "XQuartz")
* In preferences/security, allow connections from network clients
* run `xhost + localhost` in a shell terminal

## build docker image

* You must have downloaded the installation file from altera in the folder where dockerfile resides. (this is a huge file, more than 2G). The link is : <https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/QuartusLiteSetup-20.1.1.720-linux.run>
* You must also download the files for your specific FPGA, e.g. : <https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/cyclone10lp-20.1.1.720.qdz>
* These pieces of software are licensed material from Intel corporation. Please read the Licence Agreement in QUARTUS_LICENSE. The LICENSE file applies only to the Dockerfile and readme files, and not to these Intel licensed softwares.
* In a shell terminal, run `docker build -t quartus .`
* NB: don't forget the ending dot !

The resulting docker image will have a size ~10G

## run Quartus

Run this shell command: `docker run --rm -d -e DISPLAY=host.docker.internal:0 --net=host --volume=/shared/folder:/macOS/shared/folder quartus`

`/shared/folder` is a folder on macOS side (you can choose whatever folder you need). `/macOS/shared/folder` is the path of this shared folder inside the docker container, it can be accessed inside Quartus.

## macOS application

The process of launching XQuartz, and runing the docker shell command has been bundled into a macOS **Quartus ii.app** application. The user's home directory is mapped to /root inside the linux container.

This app is only a launcher : it bounces in the dock until Quartz and the quartus app are up and running, then it disapears from the dock, since Quartus runs now independently in a docker container.
