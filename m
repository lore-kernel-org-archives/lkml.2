Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2JXM4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:56:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608Ab2JXM4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:56:52 -0400
Date: Wed, 24 Oct 2012 13:56:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [GIT PULL] SPI updates for v3.7
Message-ID: <20121024125649.GG18814@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Content-Disposition: inline
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/spi-linus

for you to fetch changes up to 213d27a42ce1646989966011d2af8563feac5635:

  spi/pl022: Revert recent runtime PM changes (2012-10-23 13:27:30 +0100)

----------------------------------------------------------------
spi: Fixes for v3.7

A bunch of fixes here, mostly minor except for the pl022 which has just
been a bit of a shambles all round, the recent runtime PM changes have
as far as I can tell never worked so they're just getting thrown out.

----------------------------------------------------------------
Aaro Koskinen (1):
      spi: tsc2005: delete soon-obsolete e-mail address

Shimoda, Yoshihiro (1):
      spi: spi-rspi: fix build error for the latest shdma driver

Ulf Hansson (1):
      spi/pl022: Revert recent runtime PM changes

 drivers/spi/spi-pl022.c     |    3 ---
 drivers/spi/spi-rspi.c      |   56 ++++++++++++++++++++++++++-----------------
 include/linux/spi/tsc2005.h |    2 --
 3 files changed, 34 insertions(+), 27 deletions(-)

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh+WLAAoJELSic+t+oim9+qUP/1HHXuMfmCznXwwQt93rocwW
cc4VMKuUF7Y/Z9qE2VmklCw/nkAM3NJmJndkx9SdSH0oz46CmVOrf4431P+55crG
Htb1PNhQbdk4aAUo7LtlT/YAtSj8OvH+KFmXwVStxmTUbRwCDHz9vibTtQSX8LMz
DiUt5kanHHa5RS60Ntv2IGOSaRPry8ZTH3Yo7Q72KPeReYmJzNJ/OXB2TvdOCZ62
mt89mKZNTQRFHakgOWChlKTbPErFlWFg0rPI0sYvI2aXfyfLH88htgBBIhvlegjo
LjkGEA3fyzpJJzOSGQw6IYIxD/yAd7oWUK5vJ/YdV0KX5oWB5kovgTaqGu5PoL16
SHcvxJtoqUsFAgSEPfRAeL3ryEsznSiIUBUFU/atN9G36hUkNxBr8vPTy4b7YZo2
Xw8fqagJ7wlYR3TW2nGtfo0iyZMwQOPfjtV5srwBvRlPjy0/2mBXfvojXHMqCP3w
FYdDplNq0Eqhcdwc8kfzQUA1giJ0LHeEeQfDrUqdBftCCFSRP6itJQy6f9SG/lBk
YkMIeyqFtofJZPmgWthDV0DYm/Wclp8rx4ox3p33BTxuwYX5G89YPmY443R3KODZ
Z/ijefM8oWxuUO8NBKdCGbM1L6YKsNqTHtOW+MIFaCHsW+wQMf9zvnRzAoN718KF
BJjWnBoukQT/9a/Uxhhi
=AylG
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
