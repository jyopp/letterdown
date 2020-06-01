# Letterdown

Letterdown is a file format for distributing markdown content with media in a portable, simple, and accessible way. `.ltd` files may be digitally signed and contain metadata about their context in the author's body of work. They may also include other resources like sample projects or audio.

## Format overview

Letterdown is designed to be a stable long-term format for consuming, sharing, verifying, and archiving documents. Documents may be created, signed, verified, and used with basic command-line tools like `tar`, `openssl`, and `gzip`. These tools have been around for decades, and are included with most operating systems.

Letterdown documents are constructed as TAR archives containing markdown files, associated resources, and optional metadata. Archives may embed digital signatures, allowing both content and signing info to be distributed in a single file without nested archives or complicated verification schemes.

At its most basic, a Letterdown document is simply:

- A gzipped TAR archive with one or more markdown files and associated resources
- An optional `signature` of the above, appended into the archive with the signer's public key
- Distributed with the file extension `.ltd`

For the complete format, see the [specification](format.md).

### Why Letterdown?

It's too difficult to distribute and read unhosted content that is beautiful, accessible, and useful over the long run. Content on the open web can be changed or taken down, is hard to verify, and is often untrustworthy as a result.

Web standards continue to evolve, and HTML content that is presented wonderfully today may have rendering quirks in future browsers that make it difficult or impossible to use. Even pages formatted with accessibility in mind are often unreadable on mobile or on tablets, and vice versa. PDFs solved many of these problems for a world of letter-sized paper printouts, but they still lack critical accessiblity features and are poorly matched to direct consumption on mobile, tablet, laptop, and TV screens.

Trivial web pages can incorporate dozens of tracking scripts, invisibly abusing the browser as a general runtime environment to exfiltrate user data. Content saved for offline use often entirely fails to load in the absence of such scripts.

Email is a common delivery mechanism for subscription and long-form content, but email clients offer a very poor reading experience at best. HTML email loads remote resources to track user activity, and relies on remote images that may disappear or be replaced.

Letterdown is:

- Easily shared and archived

- Digitally signable

- Context-aware, able to refer to other documents in a cryptographically precise way

- Usable as plain text and with command-line tools when needed

- Accessible, dark-mode friendly, and adaptable to any screen

This standard shares its primary motivation with the original [Markdown](https://daringfireball.net/projects/markdown) project: to make content as readable as possible. To this end, Letterdown documents can be verified and unarchived with common command-line tools, and are human-readable and useful from the resulting files. Even in the most complex case of linked document collections, a working copy can be assembled by hand (just unarchive all preceding documents into the final document's directory).

To support an accessible, futureproofed reading experience, HTML syntax in markdown files is strongly discouraged.

### Use Cases

Letterdown was designed with some first-class use cases in mind:

- **Paid and Unpaid Subscription Content**: Newsletters, research reports, etc.
- **Standalone documents**: Essays, blog posts, quarterly reports
- **Technical articles**: Instructions, documentation, published academic research
- **Serialized Content**: Books published by chapter, essay series

Letterdown strives to be the best choice for distributing content that is primarily text and / or images, and is digitally signed, is paid writing, or depends on verifiable prior work (ie, is based on a published data set, or is responding to another author's article).

Since Letterdown files embed all of their referenced resources, they are ideal for content delivery and uploads as well. When uploading a document to a CMS or mailing list service, or generating static websites, Letterdown documents can be used to build and deploy a hosted version of the content, as well as providing a signed, offline-readable archival copy for both users and hosting providers.
