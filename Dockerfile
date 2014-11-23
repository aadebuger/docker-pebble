FROM stackbrew/ubuntu:14.04
MAINTAINER hua zhuang  "zhvxxh@gmail.com"

RUN apt-get update && apt-get clean
RUN apt-get install -q -y openjdk-7-jre-headless && apt-get clean
RUN apt-get install -y tar
RUN apt-get install -y git curl
#ADD http://mirrors.jenkins-ci.org/war/1.587/jenkins.war /opt/jenkins.war
ADD jenkins.war /opt/jenkins.war
ADD PebbleSDK-2.8.tar.gz /pebble-dev
ADD arm-cs-tools-ubuntu-universal.tar.gz  /pebble-dev/PebbleSDK-2.8
WORKDIR /pebble-dev
RUN ls
#RUN tar -C /pebble-dev -zxf /tmp/PebbleSDK-2.8.tar.gz
RUN apt-get install -y  python-pip python2.7-dev
RUN  pip install virtualenv
WORKDIR  /pebble-dev/PebbleSDK-2.8
RUN virtualenv --no-site-packages .env
RUN /bin/bash -c 'source .env/bin/activate'
#RUN source .env/bin/activate
RUN pip install -r requirements.txt
#RUN     deactivate
ENV PATH  /pebble-dev/PebbleSDK-2.8/bin:$PATH
ENV JENKINS_HOME /jenkins
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org
RUN mkdir -p $JENKINS_HOME/plugins
RUN for plugin in chucknorris greenballs scm-api git-client ansicolor description-setter \  
    envinject job-exporter git ws-cleanup ;\  
    do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \  
       -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi ; done 

RUN apt-get install -y imagemagick
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
CMD [""]
