Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1LIOPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:15:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36761 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1LIOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:15:35 -0500
Date: Fri, 9 Dec 2011 15:15:30 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 3/5] ASoC: mxs: Export symbols
 'mxs_saif_put_mclk()' and 'mxs_saif_get_mclk()'
Message-ID: <20111209141530.GI3327@pengutronix.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xGGVyNQdqA79rdfn"
Content-Disposition: inline
In-Reply-To: <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xGGVyNQdqA79rdfn
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 02:38:10PM +0100, Lothar Wa=DFmann wrote:
> Fixes the following errors with MXS sound support built as module:
> |ERROR: "mxs_saif_put_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undef=
ined!
> |ERROR: "mxs_saif_get_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undef=
ined!
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  sound/soc/mxs/mxs-saif.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
> index 487d2ff..ec66a29 100644
> --- a/sound/soc/mxs/mxs-saif.c
> +++ b/sound/soc/mxs/mxs-saif.c
> @@ -221,6 +221,7 @@ int mxs_saif_put_mclk(unsigned int saif_id)
>  	saif->mclk_in_use =3D 0;
>  	return 0;
>  }
> +EXPORT_SYMBOL(mxs_saif_put_mclk);

EXPORT_SYMBOL_GPL. I'd vote this is an implementation issue.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xGGVyNQdqA79rdfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7iGAIACgkQD27XaX1/VRvtqgCgg3AGkA2+SWQ97+dVZ9l5Udls
BD8AnjOO4KoF69/o1oj5k3gMMCbaIKSl
=NAkC
-----END PGP SIGNATURE-----

--xGGVyNQdqA79rdfn--
