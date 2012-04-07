Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2DGIAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 04:00:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41417 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2DGIAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 04:00:38 -0400
Date: Sat, 7 Apr 2012 10:00:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Huang Shijie <shijie8@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120407080032.GA17369@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <CAMiH66EC7=x0sRYhE3hpEyBemDGSRS19xguQUqKj2kuPw5Tifw@mail.gmail.com>
 <20120404122335.GD17187@pengutronix.de>
 <CAMiH66GM0RxP-z=HNkOhhPaaXCZLKPvWFy=_+aGbbGSdrsg+iQ@mail.gmail.com>
 <20120406182122.GA13649@pengutronix.de>
 <CAMiH66GxZoT-PDfkqBOFfn2jXi6n7B0jiDmMUV9GpT09J3z2yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <CAMiH66GxZoT-PDfkqBOFfn2jXi6n7B0jiDmMUV9GpT09J3z2yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> emm..
> If you think this version is ok, I will ask Artem to accept another patch:
> "  mtd/gpmi : do not include the mxs.h".
>=20
> My other patches depend on this patch. And they have been delayed for som=
e time.

Please wait at least somebody acknowledged that this has been picked up.
linux-next will break otherwise.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9/9CAACgkQD27XaX1/VRsxIwCgugHyehWGJ1ILCit1EYLs3pKA
+ZIAnjQxcB3SBClAxepGcvfzrYcTY5Fi
=QhAz
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
