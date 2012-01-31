Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2AaKeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:34:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2AaKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:34:21 -0500
Date: Tue, 31 Jan 2012 11:34:01 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/7] LPC32xx: clock.c: USB PLL fix
Message-ID: <20120131103401.GJ2471@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <1327939327-7799-6-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIOdPewhitSMo36n"
Content-Disposition: inline
In-Reply-To: <1327939327-7799-6-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VIOdPewhitSMo36n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 05:02:05PM +0100, Roland Stigge wrote:
> This patch fixes and updates the USB PLL handling. With the old driver ve=
rsion,
> the USB clock was sometimes not started correctly. The update reflects the
> driver changes in this regard from Kevin Wells.
>=20
> See also git.lpclinux.com
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

I remember we needed that fix back then as well, so I am tempted to ack
it. However, I'd like to test it but USB is currently not available. Do
you happen to have a USB fixing commit just to test (can be hackish)?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--VIOdPewhitSMo36n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8nw5kACgkQD27XaX1/VRv+xACgsAXrnCFg3gn8T4MBNZdgbRDn
PG8AniLNAw/UiNEOUxDsZUdFbM6kFHX7
=cpEf
-----END PGP SIGNATURE-----

--VIOdPewhitSMo36n--
