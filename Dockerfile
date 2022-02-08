FROM algorand/stable:latest

USER root

ENV ALGORAND_DATA /root/node/data
ENV PATH /root/node:$PATH


RUN apt-get update && apt-get install wget -y && apt-get install curl -y 
RUN cp ~/node/data/config.json.example ~/node/data/config.json \
&& sed -i '/\"Archival\"/c\\"Archival\": false,'  ~/node/data/config.json \
&& sed -i '/\"EndpointAddress\"/c\\"EndpointAddress\": \"0.0.0.0:4001\",' ~/node/data/config.json \
&& sed -i '/\"IsIndexerActive\"/c\\"IsIndexerActive\": false,' ~/node/data/config.json

WORKDIR /root/node

ADD Entrypoint.sh /Entrypoint
RUN chmod +x /Entrypoint

ENTRYPOINT ["/Entrypoint"]