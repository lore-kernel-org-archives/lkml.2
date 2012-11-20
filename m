Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2KTIfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:35:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53603 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2KTIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:35:09 -0500
Date: Tue, 20 Nov 2012 09:34:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, linus.walleij@linaro.org,
        poeschel@lemonage.de, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mfd: add viperboard driver
Message-ID: <20121120083456.GA14722@pengutronix.de>
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de>
 <1352126906-4560-2-git-send-email-larsi@wh2.tu-dresden.de>
 <20121119173036.GE18738@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20121119173036.GE18738@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Patches 2,3,4 and 5 all applied. I would really appreciate to get an ACK =
=66rom
> the i2c folks for patch #4.

I'll try to have a look this week. It fell a bit off because linux-i2c
was not in CC. I do wonder about the naming, though. VIPERBOARD is
probably the board name, but not the IP core/SoC name?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCrQLAACgkQD27XaX1/VRv/aACdH5RyuxXUqyaDuqZBGkEUXNi2
X9oAoLlxRUkmNjlOo3J6itEn/G0ztqIn
=w8Y1
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
