#!/bin/sh
echo "read plaintext file without Gramine-SGX in Docker:"
java -jar /plaintext/demo-file.txt

echo "read encrypted file without Gramine-SGX in Docker:"
java -jar /encrypted/demo-file-enc.txt

"read encrypted file with Gramine-SGX "
gramine-sgx-get-token --output kotlin.token --sig kotlin.sig
gramine-sgx kotlin
