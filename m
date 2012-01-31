Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2AaKXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:23:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39920 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2AaKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:23:14 -0500
Date: Tue, 31 Jan 2012 11:22:49 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Roland Stigge <stigge@antcom.de>, bangaragiri.g@nxp.com,
        srinivas.bakki@nxp.com, sundarapandian.andithevar@nxp.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/7] LPC32xx: clock.c: Missing header file
Message-ID: <20120131102249.GF2471@pengutronix.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
 <4F26D9DC.2000008@ru.mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Content-Disposition: inline
In-Reply-To: <4F26D9DC.2000008@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 08:56:44PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 01/30/2012 07:02 PM, Roland Stigge wrote:
>=20
> >This patch fixes the compiler warnings regarding the EXPORT_SYMBOL usage
>=20
> >Signed-off-by: Roland Stigge<stigge@antcom.de>
>=20
> >diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock=
=2Ec
> >index 1e02751..8e79313 100644
> >--- a/arch/arm/mach-lpc32xx/clock.c
> >+++ b/arch/arm/mach-lpc32xx/clock.c
> >@@ -82,6 +82,7 @@
> >   *   will also impact the individual peripheral rates.
> >   */
> >
> >+#include<linux/module.h>
>=20
>    Shouldn't <linux/export.h> be included instead nowadays?

Ack.

@Roland: Nice series, thanks for splitting things up.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8nwPkACgkQD27XaX1/VRsuXgCeMfRRwKEQXdS9ylqk2lPZV+GS
5EkAnjIPEwT4BLJFxQl3cXfjFe/zZlgv
=15jR
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
