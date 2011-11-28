Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1K1EWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:22:31 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45833 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1K1EWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:22:30 -0500
Date: Mon, 28 Nov 2011 15:22:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lars-Peter Clausen" <lars@metafoo.de>
Subject: linux-next: manual merge of the staging tree with the driver-core
 tree
Message-Id: <20111128152222.e6aeb95e31d45f44d8adf615@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_15_22_22_+1100_xXTS.g9r0SMmhe04"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_15_22_22_+1100_xXTS.g9r0SMmhe04
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/iio/adc/ad799x_core.c between commit 6e5af184f810
("staging:iio: Use module_i2c_driver to register I2C drivers") from the
tree and commit 55e4390cb04e ("staging:iio: Add missing
MODULE_DEVICE_TABLE and MODULE_ALIAS") from the staging tree.

Just context differences.  I fixed it up (see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/iio/adc/ad799x_core.c
index c0d2f88,5bedb19..0000000
--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@@ -934,4 -944,6 +935,3 @@@ module_i2c_driver(ad799x_driver)
  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
  MODULE_DESCRIPTION("Analog Devices AD799x ADC");
  MODULE_LICENSE("GPL v2");
- MODULE_ALIAS("i2c:ad799x");
 -
 -module_init(ad799x_init);
 -module_exit(ad799x_exit);

--Signature=_Mon__28_Nov_2011_15_22_22_+1100_xXTS.g9r0SMmhe04
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0wx+AAoJEECxmPOUX5FE6ukQAKJ7bN4HVyGXHvsIiyls8loU
YSbfbqgo9ajXWmoIexqH8yOcdPJyOI1a61wJfhnyxh4wU9qon7Y2BKNgRDeuJPJf
tjXz3IjHEVT8y8QTSzdgwVZ1DNnFtcXFP1S/KkblEvSGTHcvZeAJktKA7ad564FO
zw7kfF5iWIuYA6yBEl99Oc8xgdXmUgBV1ETJ51eTv+gNaopDgr5+HZCbPU2XNGop
4zkazgtKGmcokRix1Zt5MRg/yQJehjOwdXpc6HRPWu5bCbeHiupS8u8lFQbbiKFX
ssVQHVsNLU9NnCUHFjdIRwQl1z1hylHV81oGQlTK9kTyf35vAQzxchKdBsO3nl00
Zk1QgLJ8hYLZu3XlQB01MC0hUxPzqXoSsye7GhOGtGYLtNNcFs7Gt7PPmwRHsFrt
xvLBwW7E8kAXWSXL1lLDsjgKJeWbeQqDUg4zQ0GaXB77H20ikltKC+26rxrbWDng
3GQwReZI8gmObsIq/64LHAzEDpP0RONqkyB0D1vUJHVybRRUBjwcBUxHL7qcb0Ig
hTjdZqqhPFX/hn7Y0B2suA63joGSxo6Sw17ZfxiDLpX65VnV95Hna/Sj3e+CScLf
FaQciXrScZ8bT+44PQGgeWtl7ZQrce0gMSz91ejc+ENvI9MRwY4VNSM6xOotOpoY
e0Qmo6+jX0LhNJcV4G+a
=0Sih
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_15_22_22_+1100_xXTS.g9r0SMmhe04--
