Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2KCOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:09:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56852 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2KCOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:09:56 -0400
Date: Sat, 3 Nov 2012 15:09:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c-embedded for 3.7
Message-ID: <20121103140953.GA26557@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
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


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

please pull bugfixes for i2c-embedded. 2 patches are usual stuff. The
bigger patch is needed to correct a wrong decision made in this merge
window. We hoped to get the PIOQUEUE mode in the mxs driver working with
DMA, but it turned out to be too broken (leading to data loss), so we
now think it is best to remove it entirely and work only with DMA now.
The patch should be in 3.7. IMO, so users never get the chance to use
both modes in parallel.

Thanks,

   Wolfram

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-current

for you to fetch changes up to 91b370a0dbda5de92c2cf4c3bc0d18d6bf08f05f:

  i2c: tegra: set irq name as device name (2012-11-02 10:52:52 +0100)

----------------------------------------------------------------
Laxman Dewangan (1):
      i2c: tegra: set irq name as device name

Philippe Begnic (1):
      i2c-nomadik: Fixup clock handling

Wolfram Sang (1):
      i2c: mxs: remove broken PIOQUEUE support

 drivers/i2c/busses/i2c-mxs.c     |  186 +++-------------------------------=
----
 drivers/i2c/busses/i2c-nomadik.c |    9 +-
 drivers/i2c/busses/i2c-tegra.c   |    2 +-
 3 files changed, 22 insertions(+), 175 deletions(-)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCVJbEACgkQD27XaX1/VRsPOgCfZMNUMgpO43QOGLFOP6LN82PI
CtQAnRhadRmasFvR87tbSpyqmYVjsQed
=I87I
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
