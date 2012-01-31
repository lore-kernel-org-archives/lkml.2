Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2AaK1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:27:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39973 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2AaK1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:27:01 -0500
Date: Tue, 31 Jan 2012 11:26:58 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/7] LPC32xx: clock.c: warning fix
Message-ID: <20120131102658.GH2471@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-5-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Content-Disposition: inline
In-Reply-To: <1327939327-7799-5-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 05:02:04PM +0100, Roland Stigge wrote:
> This patch removes the debug warning on local_clk_disable() as done in Ke=
vin
> Wells' driver update
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Maybe this can be folded with 7/7? Otherwise

Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Wolfram Sang <w.sang@pengutronix.de>

>=20
> diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
> index 229bec5..01e9aba 100644
> --- a/arch/arm/mach-lpc32xx/clock.c
> +++ b/arch/arm/mach-lpc32xx/clock.c
> @@ -903,8 +903,6 @@ static inline void clk_unlock(void)
> =20
>  static void local_clk_disable(struct clk *clk)
>  {
> -	WARN_ON(clk->usecount =3D=3D 0);
> -
>  	/* Don't attempt to disable clock if it has no users */
>  	if (clk->usecount > 0) {
>  		clk->usecount--;

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8nwfIACgkQD27XaX1/VRtdrgCfXOmrI7/iu5VEhJQTXemYg+n8
fSoAn285/RlfzNRpdN1TSyk+vSKBUQtO
=X3h8
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
