FROM maven:3.9.3-eclipse-temurin-17-alpine AS builder

COPY ./app /app

WORKDIR /app

RUN mvn package && cp /app/target/*.jar /enclave.jar

# Enclave image build stage
FROM enclaive/gramine-os:latest

RUN apt-get update \
    && apt-get install -y libprotobuf-c1 openjdk-17-jre-headless xxd \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /enclave.jar /app/
COPY ./app/src/main/resources/demo-file.txt /plaintext/
COPY ./kotlin.manifest.template /app/
COPY ./entrypoint.sh /app/

RUN mkdir files \
    && gramine-sgx-pf-crypt gen-key -w files/wrap_key

RUN mkdir encrypted \
    && gramine-sgx-pf-crypt encrypt -w files/wrap_key -i plaintext/demo-file -o /encrypted/demo-file-enc.txt

WORKDIR /app

RUN gramine-argv-serializer "/usr/lib/jvm/java-17-openjdk-amd64/bin/java" "-XX:CompressedClassSpaceSize=8m" "-XX:ReservedCodeCacheSize=8m" "-Xmx8m" "-Xms8m" "-jar" "/app/enclave.jar" "/encrypted/demo-file-enc.txt"> jvm_args.txt

RUN gramine-sgx-gen-private-key \
    && gramine-manifest -Dlog_level=error -Denc_key=$(xxd -ps /files/wrap_key) -Darch_libdir=/lib/x86_64-linux-gnu kotlin.manifest.template kotlin.manifest \
    && gramine-sgx-sign --manifest kotlin.manifest --output kotlin.manifest.sgx

ENTRYPOINT ["sh", "entrypoint.sh"]

