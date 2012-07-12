Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab2GLKJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:09:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab2GLKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:15 -0400
Date: Thu, 12 Jul 2012 11:51:23 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 1/5] i2c: tegra: remove unused member variable
Message-ID: <20120712095123.GA27520@pengutronix.de>
References: <1341920421-23511-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1341920421-23511-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 05:10:21PM +0530, Laxman Dewangan wrote:
> Remove unused member variable "iomem" of the
> i2c device structure.
>=20
> This variable becomes unused when converted all allocation
> to devm_* in following change:
>     i2c: tegra: make all resource allocation through devm_*
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied to next, thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/+nhsACgkQD27XaX1/VRvGYgCfel/pQBhHZJ7c6Z5AfLmqNEzO
NWwAnjVIIOa7L4A7VUvxjC8r/lEKRqM/
=W9HW
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
