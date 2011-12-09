Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1LIOHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:07:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1LIOHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:07:35 -0500
Date: Fri, 9 Dec 2011 15:07:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/5] ASoC: mxs: General cleanups
Message-ID: <20111209140728.GG3327@pengutronix.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FwyhczKCDPOVeYh6"
Content-Disposition: inline
In-Reply-To: <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FwyhczKCDPOVeYh6
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 02:38:08PM +0100, Lothar Wa=DFmann wrote:
> Some textual cleanups without functional changes
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  sound/soc/codecs/sgtl5000.c |   13 ++++++-------
>  sound/soc/mxs/mxs-saif.c    |    2 +-
>  2 files changed, 7 insertions(+), 8 deletions(-)

I wonder if it is okay to change those two files in one patch, but for
the changes itself:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FwyhczKCDPOVeYh6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7iFiAACgkQD27XaX1/VRu+xQCePXcF20PBs1eC9UkPsdTVbEDj
uP8AnjqdfehO3J21XPGd6qdHT4FI2tMd
=TTiF
-----END PGP SIGNATURE-----

--FwyhczKCDPOVeYh6--
