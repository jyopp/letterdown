# FAQ

#### What kind of TAR archive is specified?

Letterdown documents must use the POSIX.1 `ustar` format, which is generally considered the most portable.

The [pax Extended Header format](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/pax.html#tag_20_92_13_03) provides additional features, but archives in `pax` format are far more difficult to sign, and extraction can produce many empty metadata files on some platforms.

#### What kind of Markdown is supported?

Consider your audience; [CommonMark syntax](https://commonmark.org/help/) should be used whenever possible to maximize compatibility and accessibility. If you are packaging a document that is already published elsewhere, you may wish to make a note in `index.md` documenting the use of other, less common Markdown syntax. Markdown syntax used must always be readable to a user when specific features are unsupported. The following table is an example of content that degrades in a reasonable way:

| Markdown Type                                              | Table Support |
| ---------------------------------------------------------- | ------------- |
| [Github-flavored Markdown](https://github.github.com/gfm/) | Yes           |
| [CommonMark](https://commonmark.org)                       | No (v0.29)    |

#### Should I use HTML tags in my Markdown?

Generally, no. Authors must never assume that Letterdown files will be rendered by a web browser or parsed by components with an awareness of HTML or browser-like formatting conventions. For both futureproofing and accessiblity, only markdown syntax should be used.

#### What about other types of files, like PDF, HTML, etc.?

The primary content of a Letterdown file should be Markdown and well-supported image formats like PNG and JPEG. Support for other file types such as PDF, HTML, etc. is not implied as part of the specification. Such files must not be placed in the root directory of the archive, but they may (and probably should) be directly listed in `index.md`.

Examples of supplemental files would be an HTML example attached to an article about web technologies, or a PDF form that should be printed and filled out. Authors should expect users to be prompted to open these files in external applications.

#### How should Letterdown documents be hosted?

Publicly-hosted documents should always be available via HTTPS at the URL used to identify the document in its `context.json`. The MIME type `application/x-tar+letterdown` should always be preferred over `application/x-tar` , to prevent browsers from automatically unarchiving files, which would make signature verification impossible for end users.

Documents should be compressed with gzip before serving. Since gzip defines "magic" headers that are mutually exclusive with the uncompressed TAR format, the same `ltd` extension is used for both compressed and uncompressed documents.

For both public and non-public documents, the document's signature should be hosted individually, at the URL obtained by appending ".signature" to the document's URL, such as "letterdown.com/spec/v1.ltd.signature" for this document. The MIME type of this file should always be `application/octet-stream`.

Using the document's digest as its ETag is encouraged. The signature should be excluded when calculating this digest, as described in the specification. This allows clients to check whether the underlying document has changed, ignoring the current signing info.

This document would be hosted with the following, recommended path layout:

```
letterdown.com/spec/
  v1.ltd (gzipped in the transport layer)
  v1.ltd.signature
  v1/
    context.json
    index.md
    index.html (generated)
    intro.md
    intro.html (generated)
    faq.md
    faq.html (generated)
```

A paywalled document might look more like the following:

```
consulting-group.com/premium/
  report.ltd (requires authentication)
  report.ltd.signature
  report/
    index.html (paywall / login form)
```

Finally, if a document is only available through another delivery platform, only the signature file would be hosted. This allows users to check whether new versions of the document exist without publicly exposing any of its content:

```
my-blog.com/gumroad
  my-book.ltd.signature
  my-book/ (redirects to https://gumroad.com/l/...)
```

#### Why put the `signature` at the end of the archive?

Appending the signature to the end of the archive allows straightforward signature generation without specialized tools; `tar --append` works just fine. It also allows applications to accumulate the archive's digest during download or verification with minimal lookahead buffering, and evaluate the signature as soon as it is encountered in the stream without needing to re-read any data.

