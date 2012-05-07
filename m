Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2EGIgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:36:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59011 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543Ab2EGIgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:36:09 -0400
Date: Mon, 7 May 2012 09:36:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120507083602.GA4415@opensource.wolfsonmicro.com>
References: <1333580415.23520.29.camel@joe2Laptop>
 <1336168477.11505.6.camel@joe2Laptop>
 <20120504220241.GA6279@sirena.org.uk>
 <1336169378.11505.10.camel@joe2Laptop>
 <20120504221333.GU14230@opensource.wolfsonmicro.com>
 <20120505160042.GA26922@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20120505160042.GA26922@ericsson.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 05, 2012 at 09:00:42AM -0700, Guenter Roeck wrote:
> On Fri, May 04, 2012 at 06:13:33PM -0400, Mark Brown wrote:

> > Right, but you need to look at the code and explain why this is a
> > problem.  For example, the case I've left quoted above reads to me like
> > the intention is "If the chip isn't one I know doesn't like this then
> > let's do it" which is a perfectly sensible thing to write.

> I can not really follow your logic here; it is difficult for me to imagine a situation
> where anything along the line of
> 	if (val != 1 || val != 2)
> would provide value other than creating confusion. Maybe you can explain that a bit further.

Yeah, I hadn't actually read the code closely enough but it's not my
main point anyway - the main point was that the reports were very easy
to ignore because they're just a paste in of the error message with no
analysis they were very likely to just get ignored unless someone has a
particular interest in the code (which is essentially what I did - I
glanced at the report but only very briefly).

Compare this with the reports from people like Julia Lawall, for example
- they tend to be very clear.  Even simply adding "...as with || they
will always be true" would've helped.

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp4ksAAoJEBus8iNuMP3dQf8P/RZUiTOxOPN1uNCKHAaJ7pJU
167Lw/y8LCKCKyoapWKHpJpS0uZj+5GEdM5CMXY0S7t0sekU66uO8pa2hex23etW
9wsyi4AqgQJ/AMeMf+SFgxONFvuU+gTtjpdMZ9E/HiD+OGZZ0SjTNIR5fzEH8oM/
d5yuffTtVs7ZH30PBgh4i7zvzLFT/mayaOeZa7rFygF5NzCxxtGA2a6IRXcXV2E3
39CaeHvhzedvGo8kVhoh9flKFs/Qx72OWNdNv2DU4rUHIY16MEIj/Q01FOGR9dQq
YrPi6r8FOChEzawXqeHxt9RXJ42rPPhy4K+X4lrLoLHdQZ1ksUNy/H9rRW+SVuMO
693FQSKwbmJNDKyz18ZiOb9Wk3qZzHIYKDlaKoZ5nBGe57Go9FqEaMgbn/+r8DTD
Rz9MMMtiG9u/vwkb2ZLbR1qjCviQUIzeQfOgeFipUaQJd8Krje97pwmfXOyi8Vrs
3CTej8oCFbwRj7liEZ4FApQe6g1teeqfUBkKS6VcsEj5N6eOC1aLBw9goAQ/Db2W
Vjdkznn7K3ccM5AapdndD89Mu7IW5qwQuN5MLUkjKjWjw5mG70sSa0WWdMN2fhcX
L6nvNV4oC3CRczktr6EmS63utOH2lahMtdiScahYzmb3Jzvysf9gShUWUdv8HTnR
6t60JJ04y5J8UETD2bZG
=rXs7
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
