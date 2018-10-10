FROM ros:melodic-ros-base

RUN apt-get update && apt-get install -y \
	python3-pip \
	nodejs \
    && rm -rf /var/lib/apt/lists/

RUN pip3 install \
	jupyterlab \
	bash_kernel

RUN python3 -m bash_kernel.install

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY .jupyter ${HOME}/.jupyter
COPY Online ${HOME}/Online
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}

CMD ["cp", "~/.jupyter/lab/workspaces/lab-a511.jupyterlab-workspace", \
	"~/.jupyter/lab/workspaces/*ros-online*.jupyterlab-workspace", "&&", \
	"jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
