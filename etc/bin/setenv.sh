export CATALINA_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:PermSize=256m"
export JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=$HOST -Dcom.sun.management.jmxremote.port=$JMX_PORT -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
