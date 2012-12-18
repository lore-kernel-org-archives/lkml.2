Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2LRNOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:14:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58741 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2LRNOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:14:07 -0500
Date: Tue, 18 Dec 2012 14:13:24 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>,
        walter harms <wharms@bfs.de>, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
Message-ID: <20121218131324.GE2612@pengutronix.de>
References: <1349645970.15802.12.camel@joe-AO722>
 <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
 <1349646718.15802.16.camel@joe-AO722>
 <20121007225639.364a41b4@infradead.org>
 <50723661.6040107@gmail.com>
 <alpine.DEB.2.02.1210081028340.1989@hadrien>
 <20121009203238.63d2275f@infradead.org>
 <alpine.DEB.2.02.1210110836030.2010@hadrien>
 <20121218124640.5b1e7176@endymion.delvare>
 <alpine.DEB.2.02.1212181335360.1993@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1212181335360.1993@hadrien>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Please note that I resigned from my position of i2c subsystem
> > maintainer, so I will not handle this. If you think this is important,
> > you'll have to resubmit and Wolfram will decide what he wants to do
> > about it.
>=20
> OK, I had the impression that the conclusion was that the danger was
> greater than the benefit.  If there is interest in it, since I think it
> does make the code more readable, I can pick it up again.

TBH, there are other things coming which have higher priority, so from
my side, currently, there is not much interest right now.

Thanks nonetheless,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDQa/QACgkQD27XaX1/VRvheACgwsK3xYgkw/pySALcMFsbOkQf
TL8An1ItUMbT2JBMRw3OkXN+pnpb073g
=H4y4
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
