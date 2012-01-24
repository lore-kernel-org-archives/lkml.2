Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2AXP7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:59:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34511 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AXP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:59:33 -0500
Date: Tue, 24 Jan 2012 16:59:21 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH] Correct bad gpio naming
Message-ID: <20120124155921.GH2609@pengutronix.de>
References: <4F1C4E25.6070801@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdvjNjn6lL3tIsv0"
Content-Disposition: inline
In-Reply-To: <4F1C4E25.6070801@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SdvjNjn6lL3tIsv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2012 at 06:57:57PM +0100, Roland Stigge wrote:
> One of the GPIO names in drivers/gpio/gpio-lpc32xx.c
> was bad. Renaming gpi000 -> gpio00
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Since you are modifying LPC32xx :) Which kernel version do you run? I
was trying to get a board up with 3.0 (not booting) and 3.3-rc1 (build
breakage). I even thought about removing that mach, since vital parts
seem to be missing (Net, NAND) or broken. So, I am interested if there
are still users.

CCing Kevin Wells, too: Any plans from NXP?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--SdvjNjn6lL3tIsv0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8e1VkACgkQD27XaX1/VRulUgCgu1U6uNVM/yBqG67jeE2pd1n8
PYYAoMnEJHDSL8jKDV3ikddLfUcOvMQE
=cOJ9
-----END PGP SIGNATURE-----

--SdvjNjn6lL3tIsv0--
