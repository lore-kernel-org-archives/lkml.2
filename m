Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2KWMNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:13:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57660 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab2KWMNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:13:46 -0500
Date: Fri, 23 Nov 2012 21:13:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps80031: Trivial cleanups
Message-ID: <20121123121341.GJ4529@opensource.wolfsonmicro.com>
References: <1353573044.18426.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
In-Reply-To: <1353573044.18426.1.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 04:30:44PM +0800, Axel Lin wrote:
> This patch includes below cleanups:
>=20
> - Fix typo in comment
> - Fix showing wrong register in dev_err
> - Remove unnecessary rinfo variable
> - Add TPS80032 to MODULE_DESCRIPTION

Applied, thanks.

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr2hvAAoJELSic+t+oim9EtEP/ilfic1PIPozFBMWhDY9791/
azA12GCXtc6gIFs9J/8UUKWYUIRplVkHPtoDamex6qip8O2phroyObIqjf6VBj+6
EkzC9lbuTROJ0Kmbs3slm131P/WA4S1JkvcHBkW843taY96gW5193B/HOAL/28/P
vGw/H302JJIC6YNEj7mu7I/uXgyAkKfMHUY4ppuEYRwWZpdjUX626TxQhiS7Hzll
Zz9+gjHS20aZuUagxgoei9F9FN+td2X5yAME20linX/KQAKRKfmuOIGbKLGW7YYv
ty+aje37U3QY6ehDk5+x/vbLS2b/iC8bO2/A6KYxtwV0Ku2tAiTa9hr+rLGrYU3F
6OONX93mXdfmdb3JNDxRusPXUK1cLRmO0SvNU5z/GhI5P5XCxThJF5Ga2K0CUfV5
RUafTSJaBtBX08AuAPrPRBNZdx7JAlIUv8WudVMTbgt23GbjSNNGFX8WZcJiYJ4l
7UvohzUHNN5YQqXl+60VH6v7MnHRwlgaMIMjHHLBwwPqkmLBfBwHdRZ4VR1IAGm8
/7NMzahYB1K+35sGo/3K7mDVFHl2dMzudiPVq/jrqAVOzCtgjyIeHOJ3DYzkGt46
rIh/uRm2PTSGXuNmkvpBVSJH+MknXD0WryEQFV9MLJTsX7Zkakx4l3y57UzMwIkz
cT8NYSXMvEcm3esnClAm
=8nMz
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--
