
# USAGE: ./build.sh output [files.txt] [path/to/private.key]
# eg, ./build.sh "Archive.ltd" file-list.txt ~/.private/letterdown.key

FILENAME=${1}
FILES_LIST=${2}
PRIVATE_KEY=${3}

if [ -n "$PRIVATE_KEY" ]; then
    # Create an UNCOMPRESSED temporary archive to sign
    tar -cv -f "temp.ltd" --format=ustar -T "$FILES_LIST"
    openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "signature" temp.ltd
    # Copy the public key
    openssl rsa -in "$PRIVATE_KEY" -pubout -out pubkey.pem
    # Copy everything in order to the final output archive.
    tar -cvz -f "$FILENAME" @temp.ltd signature pubkey.pem
else
    tar -cvz -f "$FILENAME" --format=ustar -T "$FILES_LIST"
fi
