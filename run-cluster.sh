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
echo "Starting 2 instances of the app on Payara $PAYARA_VER..."

${JAVA17_HOME}/bin/java \
      -Xmx1024m \
      -jar $PAYARA_MICRO_JAR \
      --deploy ./target/payara6-clustering-1.0-SNAPSHOT.war \
      --prebootcommandfile preboot.txt \
      --contextroot / \
      --port 8080 > instance1.log 2>&1 &

${JAVA17_HOME}/bin/java \
      -Xmx1024m \
      -jar $PAYARA_MICRO_JAR \
      --deploy ./target/payara6-clustering-1.0-SNAPSHOT.war \
      --prebootcommandfile preboot.txt \
      --contextroot / \
      --port 8081 > instance2.log 2>&1 &

echo "See the logs in instance1.log & instance2.log. Connect on http://localhost:8080/hello."