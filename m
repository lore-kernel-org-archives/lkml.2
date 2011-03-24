Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1CXDae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:30:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55816 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324Ab1CXDab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:30:31 -0400
Date: Thu, 24 Mar 2011 14:30:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110324143019.cce06baa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Mar_2011_14_30_19_+1100_VsxSfFmQEEBdV2V1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Mar_2011_14_30_19_+1100_VsxSfFmQEEBdV2V1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

lib/lib.a(show_mem.o): In function `show_mem':
show_mem.c:(.text+0x1f4): multiple definition of `show_mem'
arch/sparc/mm/built-in.o:(.text+0xd70): first defined here

This has been reported elsewhere, caused by commit ddd588b5dd55 ("oom:
suppress nodes that are not allowed from meminfo on oom kill").

I presume that this will be fixed soon, and so have left it as is.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Mar_2011_14_30_19_+1100_VsxSfFmQEEBdV2V1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNirrLAAoJEDMEi1NhKgbs4RMH/2/Z8Zi/2htq1LI+funfSy4y
v1Tf4on0em8r22x+HJ+SSTkg2Lv4jKYYl9dt6m279JReHdOD3huUJnGlKWuoWZZO
tCcLPrrzvxsemR/awwPOyjgVns/fsZ8VjkS2TRJXKWJFbU692Uk5FVHUlG3BnhlR
8HTxMdba8RLhRnWTwquzljCcCgLNFnTJfC+5izYyVCPdY2i7N3E+B+YpLKJOgt1n
7Wlo5T4XwCYuQCcH1rh+n+FwatdU+/hvnhTddtlCBLuITKqPmkw2dMj5HIdXtYW5
jrLK1IRD4cj0hWN6YN36TzP3rv+QddcNkThwnZDptNK7cgUUJDLFxdImUzY/xI4=
=kmww
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Mar_2011_14_30_19_+1100_VsxSfFmQEEBdV2V1--
