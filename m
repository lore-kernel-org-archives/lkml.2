Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2LVTYC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:24:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:23:59 -0500
Date: Sat, 22 Dec 2012 20:23:55 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c for 3.8
Message-ID: <20121222192355.GA26323@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
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


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

since 3.8-rc1 is out now, please pull the squashed patches from Bill to
get rid of the __dev* annotations in the i2c subsystem. I couldn't
include it in my previous pull request due to some dependency with the
mfd subsystem. I had this patch in linux-next for two days before rc1
and nothing popped up. Please pull.

Thanks,

   Wolfram


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-next

for you to fetch changes up to 0b255e927d47b550620dfd3475ee74b0f52e09c8:

  i2c: remove __dev* attributes from subsystem (2012-12-22 20:13:45 +0100)

----------------------------------------------------------------
Bill Pemberton (1):
      i2c: remove __dev* attributes from subsystem

 drivers/i2c/busses/i2c-ali1535.c            |    8 +++---
 drivers/i2c/busses/i2c-ali1563.c            |   10 +++----
 drivers/i2c/busses/i2c-ali15x3.c            |    8 +++---
 drivers/i2c/busses/i2c-amd756.c             |    7 +++--
 drivers/i2c/busses/i2c-amd8111.c            |    7 +++--
 drivers/i2c/busses/i2c-at91.c               |   14 +++++-----
 drivers/i2c/busses/i2c-au1550.c             |    6 ++---
 drivers/i2c/busses/i2c-cpm.c                |    8 +++---
 drivers/i2c/busses/i2c-designware-pcidrv.c  |    6 ++---
 drivers/i2c/busses/i2c-designware-platdrv.c |    6 ++---
 drivers/i2c/busses/i2c-eg20t.c              |    6 ++---
 drivers/i2c/busses/i2c-elektor.c            |    8 +++---
 drivers/i2c/busses/i2c-gpio.c               |    8 +++---
 drivers/i2c/busses/i2c-highlander.c         |    6 ++---
 drivers/i2c/busses/i2c-hydra.c              |    6 ++---
 drivers/i2c/busses/i2c-i801.c               |   28 +++++++++-----------
 drivers/i2c/busses/i2c-ibm_iic.c            |    8 +++---
 drivers/i2c/busses/i2c-intel-mid.c          |    6 ++---
 drivers/i2c/busses/i2c-isch.c               |    6 ++---
 drivers/i2c/busses/i2c-mpc.c                |   38 +++++++++++++----------=
----
 drivers/i2c/busses/i2c-mv64xxx.c            |   18 ++++++-------
 drivers/i2c/busses/i2c-mxs.c                |    6 ++---
 drivers/i2c/busses/i2c-nforce2.c            |   12 ++++-----
 drivers/i2c/busses/i2c-nuc900.c             |    6 ++---
 drivers/i2c/busses/i2c-ocores.c             |    6 ++---
 drivers/i2c/busses/i2c-octeon.c             |   10 +++----
 drivers/i2c/busses/i2c-omap.c               |    6 ++---
 drivers/i2c/busses/i2c-parport-light.c      |    6 ++---
 drivers/i2c/busses/i2c-pasemi.c             |    6 ++---
 drivers/i2c/busses/i2c-pca-isa.c            |    8 +++---
 drivers/i2c/busses/i2c-pca-platform.c       |    6 ++---
 drivers/i2c/busses/i2c-piix4.c              |   32 +++++++++++-----------
 drivers/i2c/busses/i2c-pmcmsp.c             |    6 ++---
 drivers/i2c/busses/i2c-pnx.c                |    6 ++---
 drivers/i2c/busses/i2c-powermac.c           |   16 +++++------
 drivers/i2c/busses/i2c-puv3.c               |    6 ++---
 drivers/i2c/busses/i2c-pxa-pci.c            |    6 ++---
 drivers/i2c/busses/i2c-rcar.c               |    6 ++---
 drivers/i2c/busses/i2c-s6000.c              |    8 +++---
 drivers/i2c/busses/i2c-sh7760.c             |    8 +++---
 drivers/i2c/busses/i2c-sh_mobile.c          |    2 +-
 drivers/i2c/busses/i2c-sirf.c               |    8 +++---
 drivers/i2c/busses/i2c-sis5595.c            |    4 +--
 drivers/i2c/busses/i2c-sis630.c             |    8 +++---
 drivers/i2c/busses/i2c-sis96x.c             |    6 ++---
 drivers/i2c/busses/i2c-tegra.c              |    8 +++---
 drivers/i2c/busses/i2c-via.c                |    6 ++---
 drivers/i2c/busses/i2c-viapro.c             |    4 +--
 drivers/i2c/busses/i2c-viperboard.c         |    6 ++---
 drivers/i2c/busses/i2c-xiic.c               |    8 +++---
 drivers/i2c/busses/i2c-xlr.c                |    6 ++---
 drivers/i2c/busses/scx200_acb.c             |   16 +++++------
 drivers/i2c/muxes/i2c-mux-gpio.c            |   14 +++++-----
 drivers/i2c/muxes/i2c-mux-pinctrl.c         |    8 +++---
 54 files changed, 241 insertions(+), 247 deletions(-)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDWCMsACgkQD27XaX1/VRttDgCgg8Shf8C3HdgDm1ewZyIa0OY3
KzwAmgKn8OZrYIE22hVs2Y/UqJ32YSds
=pMxk
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
