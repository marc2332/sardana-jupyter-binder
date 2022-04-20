FROM  mysql/mysql-server

FROM reszelaz/sardana-test:latest


EXPOSE 8888
EXPOSE 8050

ARG NB_USER=alba
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}



RUN chmod +x ${HOME}/docker/demo.sh

ENV SARDANA_JUPYTER_CONF=${HOME}/docker/demo-sardana-jupyter.yml
ENV TANGO_HOST=localhost:10000

# Where Jupyter-Dash litens on 
ENV HOST=0.0.0.0

# Setup
RUN apt update
RUN apt install -y git
RUN apt install -y sudo
RUN git clone https://gitlab.com/sardana-org/sardana --depth 1

# Install & setup anaconda
RUN apt install wget
USER ${NB_USER}
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh -O ~/anaconda.sh
RUN bash ~/anaconda.sh -b -p ${HOME}/anaconda3



# Setup the environment
RUN ${HOME}/anaconda3/bin/conda env create -f ${HOME}/docker/demo-environment.yml 
# Install Sardana Kernel
RUN ${HOME}/anaconda3/bin/conda run --no-capture-output -n sardana-jupyter jupyter kernelspec install ${HOME}/sardana_kernel --user 
# Build Jupyter Lab because of Jupyter Dash
RUN ${HOME}/anaconda3/bin/conda run --no-capture-output -n sardana-jupyter jupyter lab build

WORKDIR $HOME

USER root

ENTRYPOINT ./binder.sh && sudo -E PATH="${HOME}/anaconda3/envs/sardana-jupyter/bin:${PATH}" -u alba ${HOME}/anaconda3/envs/sardana-jupyter/bin/jupyter-lab $@