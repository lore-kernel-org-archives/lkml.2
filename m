Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2FRL5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:57:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48431 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab2FRL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:57:41 -0400
Date: Mon, 18 Jun 2012 12:57:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
Message-ID: <20120618115738.GI3974@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HkMjoL2LAeBLhbFV"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HkMjoL2LAeBLhbFV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 12:13:58PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 18 Jun 2012, Mark Brown wrote:
>=20
> > On Mon, Jun 18, 2012 at 11:52:13AM +0200, Guennadi Liakhovetski wrote:

> Ok, I can add an explanation, why the name changes are necessary.

Please do split it into a separate patch.

> > I suspect we should be using kstrdup()...

> I wouldn't. It would add one more kmalloc(), which is avoided with my=20
> approach, then it would make a memcpy(), which we also don't need, becaus=
e=20
> we have to print the id into the string.

This is because you've decided to go and select a particular set of
names for the supplies rather than letting people configure them which
again isn't 100% obvious...

--HkMjoL2LAeBLhbFV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3xesAAoJEBus8iNuMP3duiYP/jchpyD0uXn8nARXkGJXlLlL
dAcOIckAMFFmwa2edJ7ntKb1yqnmsN0gdLO0Jxc5KeSwFgBPlVbJlfAl8rLlHw5L
VtpSV64t0Nooa/c5inzKDZD8ZcBT6YrzaOGkKBgYOi5D8RfMHiqjn8DX1kh++6Yu
STCTf0iLHn5JfT8oH3p0tllsT/c7w/zQXwMkacvEflm8tEmWEfK0Zy8SH97bwZK4
ca1U5lNj75SVOX+NQCATO++1KwuCYWJbsrvaq+pOi+r/KF7pH+5CMHVTTkDqWoch
ohRIFHvurR85LrBfuUAm2OX5qawklghqyqg3hHByyGsJajZkbGf+h6p55zRXi2FX
mQ25IhT1d8SQ/rRoLM+1zjLZn8ntf83r+xDnw5qECh1FX+WCA+BOo4OGx9IswcRN
gY4QUpJsA6O6phsqwr3jb6uXF7MKIsHDBnRs9UNCrdNWnzijqO2yIMDOFf7/7grK
UhsIf14+OyVunQaosIbaWRSXxFWU4krybTAXyYcOgq1VQmLxYZkrH/yAZr+Pcwwd
TURdhF+vjpTUORjC3bM1sHNrCZhavskbI2L+V2s3hTlz2/6mxQodhqLtl+k5Bbab
KDhcZbKelV02UmPRzyQj63jdhu1+Ei00jCoRqmw0d8TBafI38mke98Gxh1fIjgk0
TwqqrBmOlHrhFb10tJ6q
=DMaA
-----END PGP SIGNATURE-----

--HkMjoL2LAeBLhbFV--
