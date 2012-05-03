Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2ECMcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:32:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41993 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2ECMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:32:21 -0400
Date: Thu, 3 May 2012 14:32:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c-embedded for 3.4
Message-ID: <20120503123220.GA4803@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
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


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here are some typical i2c driver bugfixes for 3.4. Missed clock
handling, improper timeout fixes, hardware wrokarounds... All patches have
been in linux-next for a few days, too.

Please pull.

Thanks,

   Wolfram

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-current

for you to fetch changes up to 1e4f0b82577e59f23484c99056c96465e202fdd5:

  i2c: mxs: disable QUEUE when sending is done (2012-04-27 16:13:29 +0200)

----------------------------------------------------------------
Alok Chauhan (1):
      i2c: tegra: Add delay before resetting the controller after NACK

Roland Stigge (1):
      i2c: pnx: Disable clk in suspend

Tomoya MORINAGA (2):
      i2c-eg20t: change timeout value 50msec to 1000msec
      i2c-eg20t: Modify MODULE_AUTHOR's email address

Wolfram Sang (2):
      i2c: mxs: handle spurious interrupt
      i2c: mxs: disable QUEUE when sending is done

 drivers/i2c/busses/i2c-eg20t.c |    4 ++--
 drivers/i2c/busses/i2c-mxs.c   |    8 ++++----
 drivers/i2c/busses/i2c-pnx.c   |    3 +--
 drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
 4 files changed, 15 insertions(+), 8 deletions(-)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+ietQACgkQD27XaX1/VRvo8wCeIpjSy7I6bwbfOSJYWQW8O7+6
BiAAn0YY8WnBV/VxbgnvaEZceFlOKSFu
=2VX2
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
