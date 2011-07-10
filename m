Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1GJJDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:03:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41419 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1GJJDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:03:48 -0400
Date: Sun, 10 Jul 2011 11:03:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: Add I2C bus support
Message-ID: <20110710090339.GA11413@pengutronix.de>
References: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110709115307.GA19804@pengutronix.de>
 <20110709140833.GA17655@opensource.wolfsonmicro.com>
 <20110709145733.GA1893@pengutronix.de>
 <20110710025922.GB19971@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20110710025922.GB19971@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

> Possibly not, actually - as Greg acked it I'm probably going to try a
> pull request during the merge window and see how that goes.
>=20
> > abstracting I2C/SPI-access away. Will surely try to convert a driver
> > myself.

Just saw you updated your repo with the fixes included. For this version, y=
ou
can add my

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

> Please send me any patches for that and I'll add them to the series.

Will do!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4ZausACgkQD27XaX1/VRuIHwCghTTMRr8+Qa5oZ15C7/vekdRW
70wAoK8GnaoO82ysL0d+ApEcnF5h3hJk
=jx9G
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
