# docker can be installed on the dev board following these instructions: 
# https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository , step 4: x86_64 / amd64
# 1) build: docker build -f amd64-usbtpu.Dockerfile -t "neuralet/smart-social-distancing:latest-amd64" .
# 2) run: docker run -it --privileged -p HOST_PORT:8000 -v "$PWD/data":/repo/data neuralet/smart-social-distancing:latest-amd64

FROM amd64/debian:buster

RUN apt-get update && apt-get install -y wget gnupg usbutils

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install -y python3-pip pkg-config libedgetpu1-std python3-wget

RUN python3 -m pip install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl 

RUN apt-get install -y python3-opencv python3-scipy

RUN pip3 install fastapi uvicorn aiofiles pyzmq

ENTRYPOINT ["python3", "neuralet-distancing.py"]
CMD ["--config", "config-skeleton.ini"]
WORKDIR /repo
EXPOSE 8000

COPY --from=neuralet/smart-social-distancing:latest-frontend /frontend/build /srv/frontend

COPY . /repo
