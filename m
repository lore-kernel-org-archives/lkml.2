Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab0KQIM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:12:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934199Ab0KQIMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:12:25 -0500
Date: Wed, 17 Nov 2010 09:12:05 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: Move lp3971 regulator driver to
	subsys_initcall()
Message-ID: <20101117081205.GB11542@pengutronix.de>
References: <1289962844.8233.2.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <1289962844.8233.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 17, 2010 at 11:00:44AM +0800, Axel Lin wrote:
> Regulators need to be available early in init in order to allow them
> to be available for consumers when requested.
>=20
> Other regulator drivers are already moved to subsys_initcall(),
> looks like only lp3971 is missing.

My 2 cents: it is safer to create such patches with real HW when there is a
need (we deal with a similar situation in i2c). Janitorial might do more ha=
rm
than good. Another option might be to call the patch a RFC?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkzjjlUACgkQD27XaX1/VRsF2QCfQn/bCEZSb0qkn1aj9SpqxsST
zlMAoIyd6I+c4XitD1KRHe53/n3wlXOQ
=MQc1
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
