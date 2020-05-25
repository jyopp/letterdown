# Building Letterdown Files

Letterdown files start as a simple TAR archive of all content and media files. If you are able to influence file order, `context.json` and `index.md` should precede all content files, and directories should be added last. Content files should be added in the same order they appear in `index.md`.

```bash
$> tar -cv -f "project.ltd" context.json index.md main.md extras.md media
```

### Using mtree (macOS, FreeBSD)

When supported, an `.mtree` file should be used to specify an archive's internal format. This file not only defines which files are included and in what order, it may be used to override or mask other filesystem properties that may not be appropriate for the final document.

##### Example .mtree file

```mtree
/set type=file mode=0644
.    type=dir mode=0755
    context.json
    index.md
    main.md
    extras.md

media type=dir mode=0755
..

..
```

This file is passed as the input list to create the archive, which will include *only* the files listed therein:

```bash
$> tar -cv -f "project.ltd" @project.mtree
```

### Adding a Digital Signature

If desired, the archive is signed at this point, and the signature appended to the `*.ltd` file:

```bash
$> openssl dgst -sha256 -sign /path/to/private.key -out signature project.ltd
```

Then, the archive and signature are combined into a new archive:

```bash
$> tar -cv -f "signed.ltd" @project.ltd signature
```

When successful, the archive contents are properly ordered, and all files are present:

```bash
$> tar --list -f signed.ltd
./
context.json
index.md
main.md
extras.md
media/
signature
```

Finally, the file should typically be compressed for distribution:

```bash
$> gzip signed.ltd -c > signed.ltdz
```

The default gzip behavior of appending `.gz` must not be used, because these archives are intended to be opened and consumed directly without decompression. Appending `.gz` would cause most operating systems to inflate the file to a directory instead of opening it as a verifiable, signed archive.

### Verifying the signature

Digital signatures are embedded in the file for ease of distribution and for easy verification in client programs. This adds a few steps to command-line verification, but it's still quite straightforward:

```bash
# Create project-inner.ltd by cloning signed.ltdz, skipping the signature file
$> tar -c --exclude signature -f project-inner.ltd @signed.ltdz
# Extract just the signature file from the archive
$> tar -x -f signed.ltdz signature
$> openssl dgst -sha256 -verify /../pubkey.pem -signature signature project-inner.ltd
Verified OK
```

##### Verifying the signature in applications

In an application, the verification process is very similar. All header and file bytes may be streamed to a SHA256 digest until the header for the `signature` file is encountered. A final 1024 padding bytes are added to the digest, as per the TAR format. Finally, the digest's sum is verified against the contents of the signature file.

// TODO: Include a golang program to verify *.ltd signatures
