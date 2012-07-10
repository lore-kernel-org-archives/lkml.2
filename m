Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2GJLPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:15:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53877 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2GJLPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:15:07 -0400
Date: Tue, 10 Jul 2012 21:14:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120710211455.b9afb0741bdc16bec4b26c03@canb.auug.org.au>
In-Reply-To: <20120710090324.GC3918@opensource.wolfsonmicro.com>
References: <20120710153210.45caf9cf0644898ab3d1c70b@canb.auug.org.au>
	<20120710090324.GC3918@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_21_14_55_+1000_FLgJeGs=EWZI6CuS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_21_14_55_+1000_FLgJeGs=EWZI6CuS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 10 Jul 2012 10:03:25 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Tue, Jul 10, 2012 at 03:32:10PM +1000, Stephen Rothwell wrote:
>=20
> > Caused by commit 01eaf2458773 ("extcon: Convert extcon_gpio to
> > devm_gpio_request_one").  devm_gpio_request_one is not currently export=
ed
> > to modules.
>=20
> A patch for this has been in -next for most of this release cycle and
> really should've been sent to Linus by now - this issue is cropping up
> an awful lot and there's further patches not getting applied due to the
> dependency on this.
>=20
> I *think* the patch is sitting in Andrew's tree at the minute.

Its actually in the gpio-lw tree (more cc's added).  It was in Andrew's
tree before that.

Linus (Walleij), Stephen, Grant, can someone please send this patch to
Linus (Torvalds)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Jul_2012_21_14_55_+1000_FLgJeGs=EWZI6CuS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/A6vAAoJEECxmPOUX5FEUNMP/jPu86esbOqb/XQTM7DbI7UD
8tUxbnTDSLPIJ0iDf7aFKZUq0rTMMHNYhuN9vgIwZAdqoglgKrscPSjBom52BC7c
FC0rEqinIklO4FWqepIFYzVrMMQl7UUo+Q/l4tSZhyOV7UBZbaCNCH0GsbIMH+Jz
g7AW+hNCl6ZAfEdYxBV1zMdI/3tPMjdLq6B3IJ4emQKxCZiolUkOIY/IMAGiey7m
XIkm8SgFfq45upcNXftVKQRkjOItBed9YqpeE6WnNim5GcwW3Y4PqeVJkW2zFTCD
WV0GML4wOENlW1pDXDLIEeDpCdRpmlyLes4ZgBbRi/O9Xb6ohfDGe7E5o4AewIdg
x4XGbQBhOhRMO7upLqC60ryRn4wSfpgCLOSOakMog91zrD2gLbWvxP0WtuTeIsde
fMDs/ZJD2sIOLEhZobrr0lo5PV9Ta9TAFRbR6C8R2joHyMPwhXJE/WuMu1U/W3QD
GlWkrUBPblKoqCJPbloOlfuNiW3nhen0au5j8g3ObY1NU/79lRjvQ3i2pXEsrhOe
yeGjJdhIhXJBYu61zbcpVA/qv856yK9epkqnvSqh9cDPvXTAEWKrGoDTMLruqDxB
MM2jkZ//2pzwRTWB0HcrXqBqCM1O5fGznI99RnmzIYbAjjNM2u8Wnqq9lZnB8g9u
Y1+a606fg4s6E119OFK2
=NFkc
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_21_14_55_+1000_FLgJeGs=EWZI6CuS--
