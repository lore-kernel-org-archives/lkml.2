Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2BPOYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:24:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42449 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2BPOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:24:00 -0500
Date: Thu, 16 Feb 2012 15:23:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Oskar Schirmer <oskar@scara.com>
Cc: wim@iguana.be, s.hauer@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: make imx2_wdt report boot status correctly
Message-ID: <20120216142356.GB2541@pengutronix.de>
References: <1329394665-7238-1-git-send-email-oskar@scara.com>
 <20120216133510.GA2541@pengutronix.de>
 <20120216141707.GA8647@curry>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20120216141707.GA8647@curry>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Seen from the perspective of code compactness ("save some lines"),
> one could try to be consequent here, and save the "val" variable
> altogether, ending up with some "new_value =3D __raw_readw ... & ... ? ..=
=2E : 0;"
> But eventually there might be code readability issues, so it's
> a good idea to keep the balance.

Yes.

> An argument for the original, longer version might be it is easier
> to extend, when more flags need to be handled, like
> "else if (val & ...) new_value =3D ...", while nested conditional
> expressions would most likely become quite complex soon.

Once we have support to handle non-stoppable watchdogs in the the new
watchdog framework, the code will be greatly refactored anyhow :)

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk89EXwACgkQD27XaX1/VRtYtwCfYjra0YsS2UyaX0VR4nM48CUZ
MPcAmwQzQyQJGlHIJgjcLycZnumhgdEF
=GIBy
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
