setup of X11 server on host side:
xhost + localhost

build container:
docker build -t quartus .

run docker container:
docker run --rm -e DISPLAY=host.docker.internal:0 --net=host --volume=/Users/edouard/vidorbase:/vidorbase quartus
