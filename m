Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2IGMxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:53:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2IGMxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:53:43 -0400
Date: Fri, 7 Sep 2012 14:53:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: guanxuetao@mprc.pku.edu.cn
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] unicore32: Add common clock support
Message-ID: <20120907125328.GB29340@avionic-0098.mockup.avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
 <1346581273-7041-5-git-send-email-thierry.reding@avionic-design.de>
 <63272.162.105.203.8.1346920926.squirrel@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <63272.162.105.203.8.1346920926.squirrel@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QGW2NLZzrRDL4mO8xHK+XzfdxTJVAabIxMyFcQT67bP
 0ZeYT96BdocKg2P/TiScSR0/XmFrsRqQcZ2jNVmP6dHgIy7rxW
 OAn1t0eoC0HL6xR2mAEj1C4lK8dARq2+3f1K0ZeeGHIInBYaHi
 u2wt93yBTl6aZW87YqIbwYUiD2qr1oDqDSpklaG4NhquxzmJHl
 eBLvm++EVRpLa3QKHz7QHFSuc6nqpQx9R2tmLXXdaCT/3GZtPd
 +Hc4XFGprBU3SaNF+G/hkOdUuZnr8LHl+q3EBjG9VlGXLgunaJ
 vdZhfvVz64bh7HQwxCzKVQX/mn4D/X2GscexGqzh3hetXhRA2j
 Q+OvdmMVRnilL0yBcfhC5tPUbSUAiEb3N4IE+Hn4n+UpXi2N87
 aFADEB33MeHjceClSyqsCWHNox/RBXNT7Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 04:42:06PM +0800, guanxuetao@mprc.pku.edu.cn wrote:
> > This commit adds support for the common clock framework to the Unicore32
> > architecture.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> This patch can't work.
> Could you disintegrate it into several small patches, so I could check it
> out.

I don't understand. How do you mean it can't work? Are you saying the
patch doesn't build, or does the system no longer boot properly? I don't
see how splitting it into smaller pieces is going to change anything
about that. Splitting it up also isn't going to work very well.
Conversion to the common clock framework is really all or nothing.

Thierry

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSe5IAAoJEN0jrNd/PrOh3qkP/ioHS3fodQ78WnSoQK6fV7E1
FZHWRqsXamCgmINnC5Xne3LGZkGEKLmpmG0xe69p0YY/KwJhrBpOQFf7gdji13N2
sBBTq8micN5gPgobsVskqcX30cAEe4RQLv+vuEkEFv+viohNWwLuErLrcvv+1ecS
p4AI12kRaIBnnlOuw6N9tcFuBJWr78Z7Dg/sIL/RbdzLOIHsDltJ0gFvFy7ZAy22
FIAGPo7vqB0rsEs+zfeTfEHMTe52TNRbfiKLSgcO0EAqOaro2xZR8VzR/TTCQ7d5
3xh4EtkqFKQjLEvd11YEECRYiUJ1pq8d95zla5UymkTWAaneGqjv3U/U7Rrfs4bz
fINLrg9tlBWyTnP6xDreKKyjcFgGCMTQvErqTpfl2BBsSkzy57WpyLi15p1LEICy
qCW8ujUpsWxaPX0Cs+Q4x5IJo35/tNC5iyRsYHJSmuW3xNHezcLUcRYhaEOXbUXU
+4lZLqLJQuEmPE6Jrl2CZShZP+FPfbUUBf4XyqKWuXTsfj4vwe7olMzrlEZ1MPgj
O9qcgugVknk90/vDzR7lzt9li422+lXBzExt4GKI80i8YtXOL6N1GpVugbs0O6xl
cugZl5up4ICGMSqUg72fAzh+jKuhWgW25Ia6Tu+SSVAhoqSXaJX0jD/9np/RqMyN
wnwSYoYN6xyNqG1VpXwG
=UVfb
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
