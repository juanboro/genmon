FROM alpine:3.22.3 AS build
ARG GENMON_VERSION

# Download genmon code at specific version
RUN apk update && \
apk add --no-cache python3 py3-pip git bash gcc python3-dev build-base linux-headers sudo && \
mkdir -p /app && cd /app && git clone https://github.com/jgyates/genmon.git && \
cd genmon && git checkout "V${GENMON_VERSION}" && \
chmod 775 /app/genmon/startgenmon.sh && \
chmod 775 /app/genmon/genmonmaint.sh 

# Update the genmon.conf file to use the TCP serial for ESP8266/ESP32 devices
RUN sed -i 's/use_serial_tcp = False/use_serial_tcp = True/g' /app/genmon/conf/genmon.conf && \
sed -i 's/serial_tcp_port = 8899/serial_tcp_port = 9000/g' /app/genmon/conf/genmon.conf && \
echo "update_check = false" >> /app/genmon/conf/genmon.conf

# Update MQTT default config
RUN sed -i 's/strlist_json = False/strlist_json = True/g' /app/genmon/conf/genmqtt.conf && \
sed -i 's/flush_interval = 0/flush_interval = 60/g' /app/genmon/conf/genmqtt.conf && \
sed -i 's/blacklist = Monitor,Run Time,Monitor Time,Generator Time,External Data/blacklist = Run Time,Monitor Time,Generator Time,Platform Stats,Communication Stats/g' /app/genmon/conf/genmqtt.conf

# Install Genmon requirements
RUN cd /app/genmon && ./genmonmaint.sh -i -n -s && ./genmonmaint.sh -r -n

# Clean out unneeded files for next stage
RUN cd /app/genmon && \
rm -rf .git .github Diagrams

FROM alpine:3.22.3
COPY --from=build /app/ /app/
COPY start.sh /app/start.sh
RUN apk update && \
apk add --no-cache python3 py3-pip bash sudo && \
chmod +x /app/start.sh

VOLUME /etc/genmon

EXPOSE 22
EXPOSE 443
EXPOSE 8000

CMD ["/app/start.sh"]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="Genmon Docker Image"
LABEL org.opencontainers.image.description="Image to run an instance of Genmon"
LABEL org.opencontainers.image.url="https://github.com/juanboro/genmon"
LABEL org.opencontainers.image.documentation="https://github.com/juanboro/genmon#readme"
LABEL org.opencontainers.image.licenses="GPL-2.0"
LABEL org.opencontainers.image.authors="Jon Krause"
LABEL org.opencontainers.image.version="${GENMON_VERSION}"
