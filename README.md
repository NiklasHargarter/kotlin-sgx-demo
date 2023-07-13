# Kotlin-SGX Demonstration: Write a file into shared protected Volume

In this demo, the contents of an encrypted file are read by a Kotlin application running in Gramine and printed to the shell for control purposes.

The Kotlin code is in the folder `/app/src`.
The build tool Maven is used to create a runnable jar file.

For demonstration purposes, an encryption key is generated locally and stored in a file. The key is used to encrypt the demo file and is also passed to Gramine-SGX to encrypt and decrypt the file when it is securely accessed.
For production use, the file should be encrypted on a trusted machine with a key provided by a secret provisioning service, and then transferred to the insecure environment; Gramine would also be provided with the key by the same provisioning service.

Locations of important files in the container:
* jar-file: `/app/enclave.jar`
* demo-file: `/plaintext/demo-file.txt`
* encrypted-file: `/encrypted/demo-file-enc-txt`
* encryption-key: `/files/wrap_key`

Sequence of commands of the entrypoint script:
* Runs `enclave.jar` with the encrypted demo-file
  * The application is unable to output the correct content due to the encryption.
* Executes the jar with the same file again but now inside Gramine-SGX
  * The correct content of the file was read, without comprimising confidentiallity and integretity due to the Gramine-SGX encryption system.
* Decrypts the file with the encryption-key and runs the jar with the decrypted file.
  * Shows that the Gramine-SGX run and execution of the jar on a decrypted file result in the same result. But the file is now exposed. 


## Building
```
docker compose build
```

## Running
```
docker compose up
```
Compare the outputs of the commands

For further testing add `tail -f /dev/null` to the end of `entrypoint.sh`. This keeps the container running and allows to access it from a second terminal

