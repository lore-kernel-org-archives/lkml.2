Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2A0WcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:32:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43495 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2A0WcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:32:22 -0500
Date: Fri, 27 Jan 2012 23:32:11 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH] Fix LPC32XX's clock.c
Message-ID: <20120127223211.GA27425@pengutronix.de>
References: <1327673868-19741-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1327673868-19741-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27, 2012 at 03:17:48PM +0100, Roland Stigge wrote:
> * Forward-ported LPC32XX's clock.c from git.lpclinux.com
> * Added MLC NAND and ADC clock
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

This needs to be split up further to make reviewing easier, I'd say. From a
glimpse, I'd guess:

- locking changes
- usb fixes
- adding MLC NAND
- adding ADC

I dunno, maybe the NXP git has the incremental changes? You should really CC
Kevin Wells on your patches. Maybe he will wake up again, at least with some
additional informaition.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8jJesACgkQD27XaX1/VRsm/ACdFQHNWF0aDVMtj2OMI4bvYZb/
A78An03KCuctkS6KBTfR4iEe4nW7jeRp
=NE9D
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
