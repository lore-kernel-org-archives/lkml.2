Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1GIO5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:57:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59242 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1GIO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:57:41 -0400
Date: Sat, 9 Jul 2011 16:57:33 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: Add I2C bus support
Message-ID: <20110709145733.GA1893@pengutronix.de>
References: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110709115307.GA19804@pengutronix.de>
 <20110709140833.GA17655@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20110709140833.GA17655@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 09, 2011 at 11:08:36PM +0900, Mark Brown wrote:
> On Sat, Jul 09, 2011 at 01:53:07PM +0200, Wolfram Sang wrote:
> > On Sat, Jul 09, 2011 at 01:50:42PM +0900, Mark Brown wrote:
>=20
> > > +#include <linux/regmap.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/module.h>
>=20
> > I second Lars-Peter with init.h here (from his first review).
>=20
> Remind me of what you're talking about here?

He suggested including init.h, because of the use of postcore_initcall.

That's minor, of course. But you probably need to resend anyway, because
of the mangling-check in the read function.

But in general: great series! I also had played with the idea of
abstracting I2C/SPI-access away. Will surely try to convert a driver
myself.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4YbF0ACgkQD27XaX1/VRv+eQCeMQvFXJHrM1B4uctQBHplZv+3
pDMAn3B4s0a5ynrN3Kdia49qMPrcrnyM
=IQ+Y
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
