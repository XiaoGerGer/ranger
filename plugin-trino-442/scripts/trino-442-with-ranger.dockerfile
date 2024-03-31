FROM trinodb/trino:442

COPY ranger-2.3.0-trino-plugin-442.tar.gz /tmp/ranger-trino-plugin.tgz

USER root
COPY jars/*.jar /tmp/jars/
COPY jars2/*.jar /tmp/jars2/

# TODO

RUN microdnf install -y gzip

RUN ranger_plugin_dir=/data/ranger-trino-plugin && \
    mkdir -p $ranger_plugin_dir && \
    tar -zxvf /tmp/ranger-trino-plugin.tgz -C $ranger_plugin_dir --strip-components=1 && \
    cd $ranger_plugin_dir/install/lib/ && \
    mv /tmp/jars/*.jar . && \
    cd $ranger_plugin_dir/lib/ranger-trino-plugin-impl && \
    mv /tmp/jars2/*.jar . && \
    # yum install -y wget && \
    # wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-auth/3.3.4/hadoop-auth-3.3.4.jar && \
    # wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.4/hadoop-common-3.3.4.jar && \
    # wget -q https://repo1.maven.org/maven2/commons-cli/commons-cli/1.4/commons-cli-1.4.jar && \
    # wget -q https://repo1.maven.org/maven2/org/codehaus/woodstox/stax2-api/4.2.1/stax2-api-4.2.1.jar && \
    # wget -q https://repo1.maven.org/maven2/com/google/guava/guava/32.0.1-jre/guava-32.0.1-jre.jar && \
    # wget -q https://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.jar && \
    # wget -q https://repo1.maven.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar && \
    # wget -q https://repo1.maven.org/maven2/org/apache/commons/commons-configuration2/2.8.0/commons-configuration2-2.8.0.jar && \
    # wget -q https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar && \
    # wget -q https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.3.2/commons-lang3-3.3.2.jar && \
    # wget -q https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar && \
    # wget -q https://repo1.maven.org/maven2/org/apache/htrace/htrace-core4/4.1.0-incubating/htrace-core4-4.1.0-incubating.jar && \
    # cd $ranger_plugin_dir/lib/ && \
    # wget -q https://repo1.maven.org/maven2/io/airlift/bootstrap/214/bootstrap-214.jar && \
    # wget -q https://repo1.maven.org/maven2/com/google/inject/guice/5.1.0/guice-5.1.0.jar && \
    cp /usr/lib/trino/lib/failureaccess-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/classmate-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/guava* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/jboss-logging-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/guice* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/bootstrap-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/log-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/configuration-* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/jakarta.* $ranger_plugin_dir/lib && \
    cp /usr/lib/trino/lib/hibernate-validator-* $ranger_plugin_dir/lib && \
    cd $ranger_plugin_dir && \
    echo 'XAAUDIT.SUMMARY.ENABLE=false' >> install.properties && \
    sed -i 's/^POLICY_MGR_URL=$/POLICY_MGR_URL=http:\/\/192.168.131.112:6080/' install.properties && \
    sed -i 's/^REPOSITORY_NAME=$/REPOSITORY_NAME=trino442/' install.properties && \
    sed -i 's/^COMPONENT_INSTALL_DIR_NAME=.*/COMPONENT_INSTALL_DIR_NAME=\/etc\/trino/' install.properties && \
    sed -i 's/#INSTALL_ENV=docker/INSTALL_ENV=docker/' install.properties && \
    sh enable-trino-plugin.sh

USER trino