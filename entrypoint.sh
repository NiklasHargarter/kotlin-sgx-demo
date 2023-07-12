#!/bin/sh

echo "run Kotlin application with encrypted file without Gramine-SGX in Docker:"
java -jar /app/enclave.jar /encrypted/demo-file-enc.txt

echo "\nrun Kotlin application with encrypted file with Gramine-SGX:"
gramine-sgx-get-token --output kotlin.token --sig kotlin.sig
gramine-sgx kotlin

echo "\ndecrypt demo-file with same key provided to the enclave"
gramine-sgx-pf-crypt decrypt -w /files/wrap_key -i /encrypted/demo-file-enc.txt -o /plaintext/demo-file-dec.txt

echo "\nrun Kotlin application with decrypted file without Gramine-SGX"
java -jar /app/enclave.jar /plaintext/demo-file-dec.txt