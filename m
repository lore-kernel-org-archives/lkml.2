Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2AaKYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:24:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39947 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2AaKYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:24:53 -0500
Date: Tue, 31 Jan 2012 11:24:50 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] LPC32xx: clock.c: jiffies wrapping
Message-ID: <20120131102450.GG2471@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8XZ+2Hy8Kj8wLPZ"
Content-Disposition: inline
In-Reply-To: <1327939327-7799-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O8XZ+2Hy8Kj8wLPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 05:02:01PM +0100, Roland Stigge wrote:
> This patch fixes the jiffies wrapping bug in clock.c.
>=20
> It corrects the timeout computation based on jiffies, uses time_before() =
for
> correct wrapping handling and replaces a binary "&" which should really b=
e a
> logical "&&" in a truth expression.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>=20
Tested-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--O8XZ+2Hy8Kj8wLPZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8nwXIACgkQD27XaX1/VRv0GgCgjH3M/uG8UN6wmDAelRnxGo1f
ghEAn2DqbINIQurY5vqUw72CfaLytNAq
=fQQY
-----END PGP SIGNATURE-----

--O8XZ+2Hy8Kj8wLPZ--
