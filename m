Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FKNgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:36:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0FKNgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:36:06 -0400
Date: Fri, 11 Jun 2010 15:36:05 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] smb380: accelerometer driver
Message-ID: <20100611133605.GB5197@pengutronix.de>
References: <4C1216FD.6010107@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <4C1216FD.6010107@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 11, 2010 at 07:59:09PM +0900, Donggeun Kim wrote:
> This patch support driver for BOSCH SMB380 and BMA023.
>=20
> This driver will read x, y, z coordinate registers from the device and
> report the values to users through sysfs interface.
>=20
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> drivers/hwmon/Kconfig | 8 +
> drivers/hwmon/Makefile | 1 +
> drivers/hwmon/smb380.c | 572
> ++++++++++++++++++++++++++++++++++++++++++++++++
> include/linux/smb380.h | 20 ++
> 4 files changed, 601 insertions(+), 0 deletions(-)
> create mode 100644 drivers/hwmon/smb380.c
> create mode 100644 include/linux/smb380.h

Please drop all i2c_set_clientdata(client, NULL).
The i2c-core does this now...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwSO8QACgkQD27XaX1/VRtBPQCfauBlZ7vRC0hdQpLWsawJJrd1
D5wAoJ14BAykA5IVknKorXpoPNVt/54Y
=B8Uw
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
