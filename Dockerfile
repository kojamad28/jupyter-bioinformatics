FROM condaforge/miniforge3:latest

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y build-essential gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ${ENV_YML} ./
ARG ENV_YML
RUN conda update -y -c conda-forge conda && \
    conda env create --file ${ENV_YML}  && \
    conda clean -i -t -y

ARG DIR_CONDA
ARG VENV
ENV PATH ${DIR_CONDA}/envs/${VENV}/bin:$PATH
SHELL ["conda", "run", "--name", "bioinfo", "/bin/bash", "-c"]

ARG REQ_TXT
COPY ${REQ_TXT} ./
RUN pip install --upgrade pip setuptools wheel&& \
    pip install --no-cache-dir -r ${REQ_TXT}

COPY . .
