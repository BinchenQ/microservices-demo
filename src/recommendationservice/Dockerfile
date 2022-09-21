FROM python:3.7-slim
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update -qqy && \
    apt-get -qqy install wget g++ && \
    rm -rf /var/lib/apt/lists/*
# show python logs as they occur
ENV PYTHONUNBUFFERED=0

# download the grpc health probe
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.11 && \
    wget -qO/bin/grpc_health_probe https://github.91chi.fun/https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# get packages
WORKDIR /recommendationservice
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# add files into working directory
COPY . .

# set listen port
ENV PORT "8080"
EXPOSE 8080

ENTRYPOINT ["python", "/recommendationservice/recommendation_server.py"]
