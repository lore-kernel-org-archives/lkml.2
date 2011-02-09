Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1BINeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 08:34:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1BINeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 08:34:05 -0500
Date: Wed, 9 Feb 2011 14:34:00 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>, Dmitry Torokhov <dtor@mail.ru>,
        "Arnd Bergmann (maintainer:GENERIC INCLUDE/A...)" <arnd@arndb.de>,
        "Andrew Morton (commit_signer:4/8=50%)" <akpm@linux-foundation.org>,
        "Mark Brown (commit_signer:1/8=12%)" 
	<broonie@opensource.wolfsonmicro.com>,
        "Anton Vorontsov (commit_signer:1/8=12%)" <cbouatmailru@gmail.com>,
        "Greg Kroah-Hartman (commit_signer:1/8=12%)" <greg@kroah.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] gpio: make newer functionality available outside of
 GPIOLIB
Message-ID: <20110209133400.GB2366@pengutronix.de>
References: <1297205075-11396-1-git-send-email-w.sang@pengutronix.de>
 <4D51CF3D.9000103@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <4D51CF3D.9000103@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Given that these functions are pretty generic and build on top of the gen=
eric
> gpio interface I think they should be available if GENERIC_GPIO is select=
ed and
> not only just through GPIOLIB. Otherwise all the archs not using gpiolib =
but
> providing the gpio api would have to be patched as well.

I agree that could be argumented for these calls. Will try something
later if nobody objects that approach.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1Sl8gACgkQD27XaX1/VRtilACfXnxlKX0baCO8Dj6/Ax0JLw7I
Jh8An3e8cIiFkGF0I2Tvz7TadpMSBTFF
=P6FG
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
