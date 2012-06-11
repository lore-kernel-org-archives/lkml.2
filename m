Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2FKDUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:20:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46420 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2FKDT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:19:59 -0400
Date: Mon, 11 Jun 2012 11:19:41 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Message-ID: <20120611031937.GA4218@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: [GIT PULL] Regulator updates for 3.5
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
regulator-3.5

for you to fetch changes up to 0bdc81e4e944781a2bcc971f9e3cf24ac7030939:

  regulator: core: Properly handle the case min_uV < rdev->desc->min_uV in =
map_voltage_linear (2012-06-08 07:15:55 +0800)

----------------------------------------------------------------
regulator: Fixes for 3.5

A couple of small fixes, plus larger fixes for the gpio-regulator driver
the most recent changes for which had apparently not been tested at all
in -next (or elsewhere from the looks of it).

----------------------------------------------------------------
Axel Lin (3):
      regulator: palmas: Fix wrong kfree calls
      regulator: anatop: Use correct __devexit_p annotation
      regulator: core: Properly handle the case min_uV < rdev->desc->min_uV=
 in map_voltage_linear

Haojian Zhuang (1):
      regulator: max8649: fix missing regmap in rdev

Heiko St=FCbner (3):
      regulator: gpio-regulator: do not pass drvdata pointer as reference
      regulator: gpio-regulator: Fix finding of smallest value
      regulator: gpio-regulator: populate selector from set_voltage

 drivers/regulator/anatop-regulator.c |    2 +-
 drivers/regulator/core.c             |    3 +++
 drivers/regulator/gpio-regulator.c   |   16 ++++++++++------
 drivers/regulator/max8649.c          |    1 +
 drivers/regulator/palmas-regulator.c |    7 -------
 5 files changed, 15 insertions(+), 14 deletions(-)

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1WOqAAoJEBus8iNuMP3dIH4QAIK1Nj9vMV2OSYshfENhuYWs
DOVUszWWzC5FakB7pin8nev0oY4aSq0nvhJuFPGaT5YNUgOMsTfTmrcOCjygaSLx
R55DZB4S681W+BDro9/Fc1w6DuLfmuEmn2pKjcTy3pAY/VmZ61NhiUcaMIboaXDX
Wqj/Htv9y611EFbY0dMcRipm4hv+3Z7WCoBXmNzpTGSG7LZ5Eh7JuN71p+X6RkZF
SAA8GEl5UoSJzzmNDYsoUBxPTRAZKQLIknZQnmrDxeekrxB25l/F/LcsLtKaVnWV
Pzq96L1iDENT+RYBh/+COYZLp1asziJAXRXQvplLk7xbQ4qwfqGt+jdd5ud8qp4C
QZe843VCMOp6W0MavyvOLNKiYzVib0EJ5lnZRtmqaflNTE4C+mExeptpXpKEyxjS
vXHXml/15W65YhcCD1Bqle8AjdON7fJfgz+ggX/DO5fiHYIDtIB5iB2VqTsTuu9B
0gEDoa9giiYrKUwcnusWs2Dyx5sawzIweIgSsQGTWTKtJscHN9QnSk6n4aBaXppK
RDiG2ikITFwuDz2BK2VBE08WGe0Ty89T5HjMBUQXtMgV717VfhOBi7DBYrrDWgQc
hpliVXsWE3j8mnb2Ba7B3gNv3Vp5nXY6viWjPU7vt4ixmSSFd9qlC3bsZw2K5hOM
jcP7re1GuDK219pONnf5
=RVCk
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
