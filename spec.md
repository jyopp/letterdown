# Letterdown

Letterdown is a file format for distributing markdown content with media in a portable, simple, and accessible way. Letterdown files (`*.ltd` / `*.ltdz`) may be digitally signed and may contain metadata about their context in the publisher's overall work. They may also include other resources like sample projects or audio.

## Format overview

Letterdown is designed to be a stable long-term format for consuming, sharing, verifying, and archiving Markdown content and associated resources and metadata. Letterdown files may be created, signed, distributed, verified, extracted, and usefully consumed without any specialized software. All of these operations can be done with basic command-line tools included with most operating systems: `tar`, `openssl`, and `gzip`.

Letterdown is a specialization of the TAR format; Archives contain markdown files, associated resources, and optional metadata. Archives may have an appended digital signature, allowing both content and signature to be distributed in a single file without nested archives or complicated verification schemes.

At its most basic, a Letterdown file is simply:

- A content archive in TAR format containing one or more markdown files and associated resources
- An optional `signature` of the archive's sha256 digest, appended after signing
  - Plus an optional file containing the corresponding public key or certificate
- Distributed with the file extension `.ltd` for uncompressed archives, or `.ltdz` for compressed archives

### What problems does this solve?

In recent years, it's become more and more difficult to distribute and store unhosted content that is beautiful, accessible, and long-term useful. Content hosted on the open web is mutable, typically unverifiable, is likely to disappear, and is often untrustworthy as a result. Web standards continue to evolve, and content that is presented wonderfully today may have rendering quirks in future browsers that make it difficult or impossible to use. In addition, even trivial pages can contain hundreds of tracking scripts, invisibly abusing the browser as a general runtime environment to exfiltrate user data.

Even content delivered to users' email inboxes relies on remote resources that may track their activity, disappear, or be replaced, and email clients are a very poor reading experience for subscription and long-form content. PDFs solved many of these problems for a world of letter-sized paper printouts, but they lack critical accessiblity features and are poorly matched to direct consumption on mobile, tablet, laptop, and TV screens.

Letterdown is:
- Easily shared and archived
- Digitally signable
- Context-aware, able to refer to other documents in a cryptographically precise way
- Accessible
- Multi-screen and Dark Mode friendly

Letterdown targets a great reading experience in applications that support it, but is also human-readable and useful in the absence of any special tooling. Even linked collections of documents can be easily verified and unarchived into a working, navigable structure by hand.

### Use Cases

Letterdown was designed with some first-class use cases in mind:

- **Paid and Unpaid Subscription Content**: Newsletters, research reports, etc.
- **Standalone documents**: Essays, blog posts, quarterly reports
- **Technical articles**: Instructions, documentation, published academic research
- **Serialized Content**: Books published by chapter, essay series

Generally, if content is primarily text and / or images, is digitally signed, is paid writing, or depends on verifiable prior work (ie, is based on a published data set, or is responding to another author's article), Letterdown strives to be the best choice for distributing it.

Since Letterdown files are digitally signed and embed all of their referenced resources, they are ideal for content delivery and uploads as well. When uploading a document to a CMS or mailing list service, or generating static websites, Letterdown documents can be used to build and deploy a hosted version of the content, as well as providing a signed, offline-readable archival copy for both users and hosting providers.

## Archive Structure

"Content File" refers to any file in the root directory of the Letterdown archive that can be rendered, *excluding* the index at `index.md`. Files that should not be presented in isolation as part of the main content sequence, must be placed in a subfolder.

Content files may be markdown or resources. A presentation may contain just PNG and JPEG images, without any markdown files beyond an index. Similarly, a file may contain the chapters of a book, installments in a series of articles, or an essay in which poems and photographs are interleaved, with separate files for each.

Letterdown requires documents to define a single default, linear order of consumption for all content files. In the absence of `index.md`, content is presented in archive order. Authors must expect applications to present content to the user in the order links appear in `index.md`, or in archival order otherwise.


### index.md

When present, `index.md` is used as the table of contents for the work, as well as its title page. Applications that handle Letterdown files should provide easy access to this file from the user interface at all times. `index.md` must contain links to all content files in the archive; Files not linked from `index.md` may be unreachable by users depending on application.

##### Example index.md

```markdown
![Cover Art](images/banner-image.png)
# Title of Work

**©2020 Author**

Written from Anywheresville, CA

- [Introduction](introduction.md)
- [Main Presentation](presentation.md)
- [Addenda](addenda.md)
```

### context.json

`context.json` contains structured metadata that places the current document into a larger context. This may identify the document as a fragment of a larger work, or cite other signed letterdown documents for user verification / interest.

#####  Fields

- **title**: The title of the document or collection.
- **url**: A globally unique identifier for this document. It is strongly recommended that the document be published at this URL. The document's `signature` file should also be available separately at `url + ".signature"`.
- **collection**: An optional, ordered array of all URLs that precede the current document in a collection. Each URL must be a Letterdown document signed with the same public key as the current document, and the current document must contain an `index.md` that covers all content in the collection (see below)
- **references**: A list of other documents and information useful in verifying their relevance and/or authenticity. References have the following fields:
  - **title**: A user-visible description of the document being linked
  - **url**: The URL of the target document
  - **signature**: Optional. The contents of the `signature` file from the referenced document, as a lowercase hexadecimal string. For documents that are not digitally signed, or are not Letterdown documents, this field is omitted

##### Example context.json

In the following example, the document is one part in a series of documents, and replaces a previous document in that series. It cites an academic paper and embeds the signature of the cited version so users can detect if the target document has changed.

```json
{ "title": "Compressing Letterdown Document Caches"
  "url": "letterdown.com/A4FC6532-EC4D-4012-8366-859903D49149",
  "collection": [
    "letterdown.com/54F42C5F-7B3D-4F63-BF22-FA0D8A1764ED",
    "letterdown.com/8F95E2FA-728B-4F36-84D5-9107A11ECA33"
  ],
  "references": [
    { "title":"R Hendricks and E Bachman, et al. \"Adversarial Compression for Peer-to-Peer Networks\"",
      "url":"domain.org/48C523A4-D3AF-4A5E-A840-C37753929FA4",
      "signature":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    }
  ]
}
```

##### Example index.md for a collection

When viewing a collection, only the `index.md` of the latest document is used. `index.md` must refer to content in other documents using full URLs:

```markdown
## A Midnight Tale

A work in progress. Thanks, as always, to my patrons! 🙇

- [Introduction](letterdown.com/54F42C5F-7B3D-4F63-BF22-FA0D8A1764ED/Introduction.md)
- [Chapter 1: Patter](letterdown.com/54F42C5F-7B3D-4F63-BF22-FA0D8A1764ED/Chapter 1.md)
- [Chapter 2: Forward](letterdown.com/6A67B622-B4E1-4B92-9156-0883A994E390/Chapter 2.md)
- [Chapter 3: Curiosities](Chapter 3.md)
- [Note to Readers](Progress Note.md)
```

##### Resolving document versions

No timestamp, publication date, or versioning fields are specified in `context.json`. If a document is published at the same URL multiple times, users may identify the most recent, canonical version of the document by:

- Fetching the canonical document signature at `context["url"] + ".signature"`
- Comparing the modification timestamps in the tar headers for the documents' `signature` files
- If no `signature` files are present, the timestamps of `context.json`, `index.md`, and content files may be checked as a fallback, but should be considered at most a hint.

