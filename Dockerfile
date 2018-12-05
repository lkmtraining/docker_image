FROM python:2

RUN apt-get update
RUN apt-get install -y lsof graphviz

CMD /bin/bash -l
