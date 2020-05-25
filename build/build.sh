
# USAGE: ./build.sh [mtree] [path/to/private.key]
# eg, ./build.sh tree.mtree ~/.private/letterdown.key

MTREE=${1:-tree.mtree}
PRIVATE_KEY=${2}

tar -cv -f "unsigned.ltd" @"$MTREE"
if [ -n "$PRIVATE_KEY" ]; then
    openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "signature" unsigned.ltd
    tar -cv -f "signed.ltd" @unsigned.ltd signature
    gzip signed.ltd
else
    gzip unsigned.ltd
fi
