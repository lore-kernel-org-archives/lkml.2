Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2FEQ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:27:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36646 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2FEQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:26:50 -0400
Date: Tue, 5 Jun 2012 18:26:47 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        swarren@nvidia.com
Subject: [PULL REQUEST] i2c-embedded for 3.5-rc2
Message-ID: <20120605162647.GA27308@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
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


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here is a pull request which only contains one new driver which had
multiple dependencies (pinctrl, i2c-mux-rework, new devm_* functions),
so I decided to wait for rc1. Plus, it had to wait a little for the ack
of a devicetree-maintainer since the bindings were not trivial enough
for me to pass through. So, given that, I hope there is still something
like the "new driver rule", so we could have the driver in 3.5 and
people can start using it. That would make merging support for some
boards easier for 3.6 since the dependency on this driver is gone then.

Thanks,

   Wolfram

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-current

for you to fetch changes up to ae58d1e406986f31d1e88b32f5ac601506c196d8:

  i2c: Add generic I2C multiplexer using pinctrl API (2012-06-04 16:49:43 +=
0200)

----------------------------------------------------------------
Stephen Warren (1):
      i2c: Add generic I2C multiplexer using pinctrl API

 .../devicetree/bindings/i2c/i2c-mux-pinctrl.txt    |   93 +++++++
 drivers/i2c/muxes/Kconfig                          |   12 +
 drivers/i2c/muxes/Makefile                         |    1 +
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |  279 ++++++++++++++++=
++++
 include/linux/i2c-mux-pinctrl.h                    |   41 +++
 5 files changed, 426 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mux-pinctrl.t=
xt
 create mode 100644 drivers/i2c/muxes/i2c-mux-pinctrl.c
 create mode 100644 include/linux/i2c-mux-pinctrl.h

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/OM0cACgkQD27XaX1/VRtsJQCfbwsqLA734Dj4nWCNrrGAd7a9
BhsAmgNR3W2z7QaWRJx8BxmWQcwLBUvn
=zILr
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
