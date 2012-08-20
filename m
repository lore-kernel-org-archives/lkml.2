Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2HTTLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:11:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab2HTTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:11:06 -0400
Date: Mon, 20 Aug 2012 20:11:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant@secretlab.ca>
Subject: [GIT PULL] spi updates for 3.6
Message-ID: <20120820191102.GL26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S6vg04ofUPzW4qJg"
Content-Disposition: inline
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S6vg04ofUPzW4qJg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/spi-3.6

for you to fetch changes up to af36107968f1b5faab0e4a0cc44fa4498c63f017:

  spi/coldfire-qspi: Drop extra calls to spi_master_get in suspend/resume functions (2012-08-17 22:46:41 +0100)

----------------------------------------------------------------
spi: Updates for 3.6

Grant is still away so another pull request with some fairly minor
fixes, the most notable of which are several fixes for some common error
patterns with the reference counting spi_master_get/put do.
-

----------------------------------------------------------------
Guenter Roeck (3):
      spi/bcm63xx: Ensure that memory is freed only after it is no longer used
      spi: spi-coldfire-qspi: Drop extra spi_master_put in device remove function
      spi/coldfire-qspi: Drop extra calls to spi_master_get in suspend/resume functions

Michel JAOUEN (1):
      spi/pl022: fix spi-pl022 pm enable at probe

Sachin Kamat (1):
      spi/s3c64xx: Add missing static storage class specifiers

Shubhrajyoti D (1):
      spi: omap2-mcspi: Fix the error handling in probe

 drivers/spi/spi-bcm63xx.c       |    4 +++-
 drivers/spi/spi-coldfire-qspi.c |    5 ++---
 drivers/spi/spi-omap2-mcspi.c   |    6 ++----
 drivers/spi/spi-pl022.c         |    1 -
 drivers/spi/spi-s3c64xx.c       |   12 ++++++------
 5 files changed, 13 insertions(+), 15 deletions(-)

--S6vg04ofUPzW4qJg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMou2AAoJEFJkBDiqVpZ4SNcQAJmGixTdGSWir6mUp2E1MVoX
bbNIVYu0yCGlhg7/sUCkQxtmMXOVoSv6GFtrp/hpAJ+eacLumFYDsusLnUjtTYZm
KabHPP7Mb+h2Qum83uq/aie7xc4t7/HA8qkuL5zRZzHKXHX/HpsN/5if0Fs20fWt
XAL57G4G9ji4S+PKSZvNvV6zPuVKJadjSxx2mtzPzooDnRaNrEwJ8A8zgI6k8vFQ
FAVAx4dzUG4zkE4NhAQJQXzk+Y4gaQbuBJvnZ9+vpIOIwfwmnEoJQokQ9fyAX2bN
1a6sun+1+bkN2D9IABs6W3B7qH8xE1nYTRHDqXk1eQPIAEnTfEZ/Fcb54apz65Me
bW/WmJmzcsaoBDwP9HC/piyUkK/bLRz1jHGa8McSZuGMcl7L/rR4kmEcmn+PV/sJ
Xg+I73BGJRaYFv9FOIQGWIUgXunZ322YfhQaJqSUTVucRKWomlvcmBLZAdnLjTzZ
Q7GyNAaSIZZgXY/ttwxHwv3C4mK2P6b081ZvPvLs1jZY27sKEP/JHMWnep2QedP2
gwZaVt8GSCI3a4OOb+f8TZsDKD4AtOMfPIYp8nslWBpHSJZ+9c4mkwv5fS3NucRC
elOS3pqZ0m4B6IZK6DCr4Q67vwBNmHiq/IpuSQ694FkC7RXe+JXEN3/lt04DKtR2
bt1EZP6c6YH+VovtnXn0
=Nfu8
-----END PGP SIGNATURE-----

--S6vg04ofUPzW4qJg--
