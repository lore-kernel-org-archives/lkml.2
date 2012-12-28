Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2L1AtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:49:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52256 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2L1AtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:49:09 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7a-50dcec832080
Message-id: <1356655735.16178.179.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add missing pretech.h include
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Fri, 28 Dec 2012 09:48:55 +0900
In-reply-to: <20121227143424.GB3223@osiris>
References: <20121227143032.GA3223@osiris> <20121227143424.GB3223@osiris>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-tXSm30HEE4bMcFX7t027"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZkW7zmzsBBh92Wlvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXM/XCCpWAaX8WONbeZGhgv8XQxcnJICJhInP54kRHC
	FpO4cG89WxcjF4eQwDJGifld+5lgil4sP88EkZjOKHH39i4WCOc1o8STH6/YQap4BfQk2l8d
	BOsQFrCQ2PD+G2sXIwcHm4C2xOb9BiBhIQFFibf774KFRUDKrzmChJkFMiQ+rX4ENoVFQFVi
	8cHzYFM4gTp3b5/JCNHqKbHo0k42EJtfQFTiZOsnRojeKolr31+xQNypJLG7vRPqGkGJH5Pv
	sUDMFJD4NvkQC8haCQFZiU0HmEGulxC4xi6x8MImqB8lJQ6uuMEygVF8FpKxs5CMgohrSrRu
	/80OYWtLLFv4mhnCtpVYt+49VI2NxKarCxghbHmJ7W/nMC9gZF/FKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERKT0jsYVzVYHGIU4GBU4uFd1HMnQIg1say4MvcQowrQnEcbVl9glGLJy89L
	VRLhXXIVKM2bklhZlVqUH19UmpNafIgxGejTicxSosn5wDSSVxJvaGxsYmZiamJuaWpuSpqw
	kjhvs0dKgJBAemJJanZqakFqEcwWJg5OqQbGptl2ArO/55S7fdu2b1rolrPzkyfX37vwodj9
	zUybmCtKvbUavRJSJcsf/FYwcXJhe7pw0Qy/HxPmGX2sPPXb3fPC4qCCtw6bmDvMLtUx3ly7
	zWq91meL8JPN0bZz00XSwwUiZl7eUH5v510eGffOk78r3x69vEitrvxG7QKuqaI1s5aeSPr2
	S4mlOCPRUIu5qDgRAAQYmRgZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3mN3cCDD4dNrPYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmPvhBEvBNL6K
	HWtuMzUwXuLpYuTkkBAwkXix/DwThC0mceHeerYuRi4OIYHpjBJ3b+9igXBeM0o8+fGKHaSK
	V0BPov3VQbAOYQELiQ3vv7F2MXJwsAloS2zebwASFhJQlHi7/y5YWASk/JojSJhZIEPi0+pH
	YFNYBFQlFh+E2MsJ1Ll7+0xGiFZPiUWXdrKB2PwCohInWz8xQvRWSVz7/ooF4k4lid3tnVDX
	CEr8mHyPZQKj4CwkZbOQpCDimhKt23+zQ9jaEssWvmaGsG0l1q17D1VjI7Hp6gJGCFteYvvb
	OcwLGNlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH/DPpHYyrGiwOMQpwMCrx8C7quRMg
	xJpYVlyZe4hRBWjOow2rLzBKseTl56UqifAuuQqU5k1JrKxKLcqPLyrNSS0+xJgMDI2JzFKi
	yfnAJJVXEm9obGJmZGlkZmFkYm5OmrCSOG+zR0qAkEB6YklqdmpqQWoRzBYmDk6pBsZ8fbaJ
	f08/EDKu+tPZ9be5V6yL7d/lZh7Hji0sHd529ZsZ5j2r3hG7bd//a49ivIuV0zYphTJYJu4J
	+RskHmpSa9rnW/4/+pWTXU/FBMH/31SvpfzbXPNzGXeZU11kdsiFE3Zyrkf1ZN57Xa7bc+rU
	h8Yd5/bOzH/xwjiK/3tI8bw9zBv95imxFGckGmoxFxUnAgAEaIe+SAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tXSm30HEE4bMcFX7t027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2012-12-27 (=EB=AA=A9), 15:34 +0100, Heiko Carstens:
> On Thu, Dec 27, 2012 at 03:30:32PM +0100, Heiko Carstens wrote:
> > From aa027f06dfb5b2fd27d6f92391d8340df671e82b Mon Sep 17 00:00:00 2001
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date: Thu, 27 Dec 2012 15:22:27 +0100
> > Subject: [PATCH] f2fs: add missing pretech.h include
>=20
> That should have been "prefetch.h", obviously...
> At least the patch is correct.

Hi,
This was fixed by Geert Uytterhoeven before.
I'm supposed to push other bug fixes with this to linus today.
Anyway, thank you very much. :)

--=20
Jaegeuk Kim
Samsung

--=-tXSm30HEE4bMcFX7t027
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ3Ox3AAoJEEAUqH6CSFDSiSIP/RcYhLjhOpxcmJj9hgmHoEDO
96d9C5Nrmvsv0ibe0yDnwLRLzkWyYaVOWwpLKCWDiISHUeH/CGRp41riZM3dAZjB
ZEKsyRgMQ/jlaRFNw3h+jvIrS/6JhasYaE41FjxAd2gdcwFlAamFp6IG40JzQs4/
YThRtV3RKCeXC7keeZwlzxOqp/SIzBvP7xJDQnlIjCami+ZvzMY17TIZ7sR06mQL
SkmoFsMbcmZk4xobmNR6YhhRDljHxSznEMDNiJw1uSdPzLTi6TyH4CjtohaQ24Ud
67dvnq0d80geFz2uZlyLIiWIIKOZXT/E5IC0RmHGCCq0yBPZNZEocrIpVFom57SP
ahzkCKDadbQMDJ/cjkXNGtJA5+LitPBS8CN0+iBTIex1OAlOOZy7mzTj+qVW3ypm
sG4ux+DXRO7SOpXeoCZ8fVG8xRG98m/wIUvZeDn0uWd8JoYRrm16copDX6+Qlrd9
lK4PCM4umrMfxFCgbsRk+c/HSuuYcTD8sC6le6ZH7t4rxeyHw2knxY1sIXCuh8HO
aO3SuX9IABzqXkjX/KTgNo+b/9u0poLBcgI9FE1rctkor5C1RHmy0CaVbVAQsJXS
X48iqu+UgLKznIV37WtCcpMi4mM46CIbo4dqDqscMTIxUwPoPgwk+5QN8iJ9U0bv
31yaaWscuiEgZK+qzD4N
=mD4g
-----END PGP SIGNATURE-----

--=-tXSm30HEE4bMcFX7t027--

