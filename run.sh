#!/usr/bin/env bash

PAYARA_VER=$(mvn help:evaluate -Dexpression=payara.version -q -DforceStdout)
PAYARA_MICRO_JAR="${HOME}/.m2/repository/fish/payara/extras/payara-micro/${PAYARA_VER}/payara-micro-${PAYARA_VER}.jar"
SERVICE=sslprovider-service

if [[ ! -f "$PAYARA_MICRO_JAR" ]]; then
  echo "Downloading payara-micro-${PAYARA_VER}.jar..."
  mvn dependency:get -Dartifact=fish.payara.extras:payara-micro:${PAYARA_VER}
  [[ -f "$PAYARA_MICRO_JAR" ]] \
    && echo "Download successful" \
    || { echo "Download failed"; exit 1; }
fi

JAVA17_HOME=${JAVA17_HOME:-/opt/java17}
JAVA_HOME=${JAVA17_HOME}

#       --clustermode multicast \
# --hzconfigfile ./docker/hazelcast-aws.xml \
# -Xdebug -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006 \
  #
echo "Starting the app on Payara $PAYARA_VER..."

${JAVA17_HOME}/bin/java \
      -Xmx1024m \
      -jar $PAYARA_MICRO_JAR \
      --deploy ./target/payara6-issues-testbed-1.0-SNAPSHOT.war \
      --nocluster \
      --contextroot / \
      --port 8080
