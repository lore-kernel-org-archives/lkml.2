Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab2CUUai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:30:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54257 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760293Ab2CUUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:30:35 -0400
Date: Wed, 21 Mar 2012 20:30:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, m.szyprowski@samsung.com,
        thomas.abraham@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, t.stanislaws@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
Message-ID: <20120321203032.GQ3226@opensource.wolfsonmicro.com>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-3-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z87VqPJ/HsYrR2WM"
Content-Disposition: inline
In-Reply-To: <1332357113-2973-3-git-send-email-k.lewandowsk@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z87VqPJ/HsYrR2WM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2012 at 08:11:52PM +0100, Karol Lewandowski wrote:
> Reorganize driver a bit to better handle device tree-based systems:
>=20
>  - move machine type to driver's private structure instead of
>    quering platform device variants in runtime
>=20
>  - replace s3c24xx_i2c_type enum with unsigned int that holds
>    bitmask with revision-specific quirks

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--z87VqPJ/HsYrR2WM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPajphAAoJEBus8iNuMP3dMwwP/jgjBp+gspHKZZlU3EX9OZzl
9shg8+4X22tppGQziiCZkqeWmaaHExVyFBvBIcLvpb1WRcroJafLEFqrC5O/AOKr
C2G3S16Q3NYvrGShGVqxU6M1FSges8v4y0PKkClSzcdot8FsAKr035aFw19LblRv
3HlZhiKQTNDivzVW31UkmkKMf+Kvqg3eJmwyT6RXwkRMEP1AmjXLSXxDfafFGFOJ
qN7krly9N8A/vBZOFiAC6TS8zepGIYR3lwU/9rSYyMeDprEgcEayL7FwoTKAawQC
MCl1ZvRolJViIkrhivYk/sGXo0f7144q1Vf5324qiVl7Tjh57hYxwxhynCXDJVUB
P0IkBXKq+3fcskvTsLkbJy9r0EfnHD3AQWOziQHv4dnvwnZUC58nYgtq2lzIyL4/
KzpqjGc+Kgw3VIfzEAyBIiNo+LVyVJfugL22169CZZrs7mOxcVkOG/Tbt27tei2w
S3k01hLSmaWCotgAcwNzTLh7wqaSxs5RAp8TRcXCvcQhgCvgNnYpHo+3vVrutfHA
+szVZl6ZEf58RLm9ehpI/7bp5G8cWgJXJaYv7Z4mv6KrAIBVQzsKVcCLvp2eaZfS
Oq3RA8j6eLTjAKxoz33ABY9daAPYaRZlDN3cgTiS4+HXk40UF63uLvjGs9D+FJAY
HaCuFRAm1MngMv1Y8l+l
=ANMQ
-----END PGP SIGNATURE-----

--z87VqPJ/HsYrR2WM--
