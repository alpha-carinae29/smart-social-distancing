FROM openvino/ubuntu18_runtime

USER root

RUN apt-get update && apt-get install -y pkg-config libsm6 libxext6 libxrender-dev

RUN pip3 install --upgrade pip setuptools==41.0.0 && pip3 install opencv-python wget fastapi uvicorn aiofiles pyzmq scipy image

CMD source /opt/intel/openvino/bin/setupvars.sh && python3 neuralet-distancing.py --config=config-x86-openvino.ini
WORKDIR /repo
EXPOSE 8000

COPY --from=neuralet/smart-social-distancing:latest-frontend /frontend/build /srv/frontend

COPY . /repo
