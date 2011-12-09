Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1LIORc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:17:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1LIORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:17:31 -0500
Date: Fri, 9 Dec 2011 15:17:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/5] ASoC: mxs: Add missing MODULE_LICENSE("GPL")
Message-ID: <20111209141728.GJ3327@pengutronix.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <a541450341a475b27ef603c5a4a67f113ba7fa0c.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdJFN6SSISdF2ksn"
Content-Disposition: inline
In-Reply-To: <a541450341a475b27ef603c5a4a67f113ba7fa0c.1323436034.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdJFN6SSISdF2ksn
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 02:38:11PM +0100, Lothar Wa=DFmann wrote:
> The sound driver refuses to load as module, because of the missing
> MODULE_LICENSE("GPL").
> The file header indicates that the driver is indeed published under
> the GPL.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Sascha's code was also GPL and this code was derived from it.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdJFN6SSISdF2ksn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7iGHgACgkQD27XaX1/VRuu2QCfU5yW+aR4Od6mTt5RoEK23Gel
dnwAoJJOqUseufeODEsCY3IZKkk1p/bZ
=ley2
-----END PGP SIGNATURE-----

--sdJFN6SSISdF2ksn--
