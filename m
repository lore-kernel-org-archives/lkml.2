Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2KWOTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:19:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50287 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KWOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:19:52 -0500
Date: Fri, 23 Nov 2012 15:19:47 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c-embedded for 3.7
Message-ID: <20121123141947.GA22986@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
X-Mutt-PGP: S<0x7D7F551B>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

please pull the bugfixes for the i2c subsystem. Except for a few
one-liners, there is mainly one revert because of an overlooked
dependency. Since there is no linux-next at the moment, I did some extra
testing, and all was fine for me.

Thanks,

   Wolfram

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-current

for you to fetch changes up to 958f9889950ef257f601c4902137caff291d5dd7:

  i2c: mxs: Handle i2c DMA failure properly (2012-11-22 23:03:34 +0100)

----------------------------------------------------------------
Abhilash Kesavan (1):
      i2c: s3c2410: Fix code to free gpios

Felipe Balbi (1):
      i2c: omap: ensure writes to dev->buf_len are ordered

Ludovic Desroches (1):
      i2c: at91: fix SMBus quick command

Marek Vasut (1):
      i2c: mxs: Handle i2c DMA failure properly

Paul Walmsley (1):
      Revert "ARM: OMAP: convert I2C driver to PM QoS for MPU latency const=
raints"

 arch/arm/plat-omap/i2c.c         |   21 +++++++++++++++++++++
 drivers/i2c/busses/i2c-at91.c    |    7 ++++++-
 drivers/i2c/busses/i2c-mxs.c     |    2 ++
 drivers/i2c/busses/i2c-omap.c    |   36 +++++++++++++++++-----------------=
--
 drivers/i2c/busses/i2c-s3c2410.c |    1 +
 include/linux/i2c-omap.h         |    1 +
 6 files changed, 48 insertions(+), 20 deletions(-)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCvhgMACgkQD27XaX1/VRsmlgCgxrZAOMkVAE35hAeq5YM2lLS/
UY0AoMiaRItuV7Ob8n5AY7Jb1Ub+8vWj
=cH/t
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
