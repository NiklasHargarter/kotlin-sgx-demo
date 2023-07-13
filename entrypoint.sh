#!/bin/sh
echo "\n###################################################################################"
echo "direct run with encrypted file"
echo "\###################################################################################"
echo "run Kotlin application with encrypted file without Gramine-SGX in Docker:"
java -jar /app/enclave.jar /encrypted/demo-file-enc.txt

echo "\n###################################################################################"
echo "Gramine-SGX run"
echo "\###################################################################################"
echo "\nrun Kotlin application with encrypted file with Gramine-SGX:"
gramine-sgx-get-token --output kotlin.token --sig kotlin.sig
gramine-sgx kotlin

echo "\n###################################################################################"
echo "direct run with decrypted file"
echo "\n###################################################################################"
echo "\decrypt demo-file with same key provided to the enclave"
gramine-sgx-pf-crypt decrypt -w /files/wrap_key -i /encrypted/demo-file-enc.txt -o /plaintext/demo-file-dec.txt

echo "\nrun Kotlin application with decrypted file without Gramine-SGX"
java -jar /app/enclave.jar /plaintext/demo-file-dec.txt

echo "\n###################################################################################"
echo "conclusion"
echo "\###################################################################################"
echo "\nThe Gramine-SGX run and direct Run with the decrypted file both achieve the same output. \nBut the in the Gramine-SGX run the file is never stored in a decrypted state on the system."
