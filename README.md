# Dockerfile for [Genmon](https://github.com/jgyates/genmon)

Based on the work that [philmichel](https://github.com/philmichel/genmon/blob/master/Dockerfile), 
[m0nger](https://github.com/m0ngr31/genmon/blob/master/Dockerfile), [skipfire](https://github.com/skipfire/genmon-addon/blob/main/docker/Dockerfile), [JMVS](https://github.com/JMVS/genmon-docker/blob/main/docker/Dockerfile), and [gregmac](https://github.com/gregmac/Genmon-ESP32-Serial-Bridge) did originally. This project is scripted to automatically publish versions weekly.

This is specifically made for compatibility with ESP8266/ESP32 devices like the [mine](https://github.com/juanboro/esphome/tree/mymaster/juanboro/tcp_server) or the [DIY Version](https://github.com/gregmac/Genmon-ESP32-Serial-Bridge).  My fork specifically attempts to slim down the container size while also assuring that all dependencies are installed in the image (prevent genmon from downloading dependencies on startup)

## Usage Example
```sh
docker run -d \
    -e TZ="America/New_York" \
    -p 8000:8000 \
    -v config_dir:/etc/genmon \
    --name genmon \
    juanboro/genmon:latest
```

## Home Assistant Setup
Look at the documentation here: https://github.com/gregmac/Genmon-ESP32-Serial-Bridge

## Multi-arch Image

The latest release is available for amd64/x86_64, aarch64/ARMv8, ARMv7, and ARMv6. Usually docker should automatically download the right image.

`docker pull juanboro/genmon:<TAG>` should just work.
