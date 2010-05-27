Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab0E0VmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:42:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40339 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab0E0VmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:42:16 -0400
Date: Thu, 27 May 2010 23:42:09 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Robert Emanuele <rob@emanuele.us>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-kernel@vger.kernel.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-i2c@vger.kernel.org
Subject: Re: Controlling Driver Load Order
Message-ID: <20100527214209.GC5636@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com> <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com> <20100526235246.GA31068@pengutronix.de> <AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com> <20100527041358.GA14070@pengutronix.de> <AANLkTilKUfcYsPqr5kXlONJQAFCaE8D8U9ltQybIzCPu@mail.gmail.com> <4BFEDF6D.3090100@bluewatersys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <4BFEDF6D.3090100@bluewatersys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Looks like this has already been done:
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg03056.html

Always ask which kernel is used, sigh...

>=20
> There was a discussion a while back to make all of the embedded i2c
> busses be subsys_initcall since i2c is often a system bus on embedded

Oh, where was that? Can't recall (but couldn't recall that I acked the i2c-=
gpio
patch above as well ;))

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv+5zEACgkQD27XaX1/VRsK0wCgwJS6Sk3E5y/b68RobX0/k+Zj
wzcAoMhiZ2z41KEzidAg8BI0i2/tt2jy
=c37a
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
