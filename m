Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1LIOMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:12:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1LIOMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:12:06 -0500
Date: Fri, 9 Dec 2011 15:12:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: mxs: add .owner to struct
 snd_soc_card
Message-ID: <20111209141203.GH3327@pengutronix.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nOM8ykUjac0mNN89"
Content-Disposition: inline
In-Reply-To: <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nOM8ykUjac0mNN89
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 02:38:09PM +0100, Lothar Wa=DFmann wrote:
> This will prevent the module from being removed from underneath its
> users
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

I can't find any other instance setting owner in snd_soc_card?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--nOM8ykUjac0mNN89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7iFzMACgkQD27XaX1/VRt/zwCgq+LQLj2jPv0Rz+1VcxR18Dpq
CsIAn1JGUDFY7mdDV9NpDIwbNUfOa5Wq
=c1mi
-----END PGP SIGNATURE-----

--nOM8ykUjac0mNN89--
