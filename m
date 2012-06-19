Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2FSLjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:39:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41177 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab2FSLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:39:04 -0400
Date: Tue, 19 Jun 2012 12:39:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator fixes for 3.5
Message-ID: <20120619113902.GM3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m8RPluiNA7RIyL8J"
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m8RPluiNA7RIyL8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 0bdc81e4e944781a2bcc971f9e3cf24ac7030939:

  regulator: core: Properly handle the case min_uV < rdev->desc->min_uV in map_voltage_linear (2012-06-08 07:15:55 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.5

for you to fetch changes up to ea851f4f08eb366e829abb8f1b2f1741a19ed696:

  regulator: Change db8500-prcmu match names to reflect Device Tree (2012-06-17 18:27:49 +0100)

----------------------------------------------------------------
regulator: Fixes for 3.5

One small bug fix, plus a rename of all the ST Ericsson regulators in
the device tree since all the device trees had been written with
different names and some infelicities in the test proceedures meant that
the device tree code had apparently never actually been run against the
upstream device tree.

----------------------------------------------------------------
Lee Jones (2):
      regulator: Change ab8500 match names to reflect Device Tree
      regulator: Change db8500-prcmu match names to reflect Device Tree

Sangbeom Kim (1):
      regulator: Fix the s5m8767a problem of the division by null

 drivers/regulator/ab8500.c       |   22 ++++++++++-----------
 drivers/regulator/db8500-prcmu.c |   40 +++++++++++++++++++-------------------
 drivers/regulator/s5m8767.c      |    2 +-
 3 files changed, 32 insertions(+), 32 deletions(-)

--m8RPluiNA7RIyL8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4GTPAAoJEBus8iNuMP3dMskP/jQ+0Avk8ptcLTjgUq0xD3TW
bW3P7Bz7Seyqu4nrgwDFgzWMyZVI5HsQnKZX66AAmqNrkkDk3tJm9vmKklpqStF5
P2beYQODE2839wsDN47z+PDDf4NxKQaO5dizK68laURY9p3F4opg0iw24xYfiuE5
OI5RqUgxFWBBmgGsx66/ZkuUmcEeAydvXwjW3nLurHfwV31gsFN6RLgkv2pcAtXa
k2bKQNJ0mqC5QH01o/U8uXUS27YMUsW0KPTmYcGcOrZoAWm3Pn9EDTAJ49xQIy6A
VTu4402B5380YL2Lwlw7aPOlIATznIMxiwQiJI3zZc5wVJOKIriLrrsLmZQbfo+y
96ubTvtQf5zaEyttamNntYzqXN2oeYfe36YCUiEiZ+OysWVRF1tvOAtu+/dA+Kv2
FT9blktSYff6RtscH4r0NVkIm14YeplSr9CDC6PNa5VpL4zOLT8PPSPy8xRVIznN
5GLaz59lzL+IwfNLL4Sz6uCJ9269sHrDb1B72+O8CR+hUnrGEOhZrKc0Q+oppk08
YYOBOI455YCEME9jp8ua6y9ubqbbRv3dyR08JTafDaOEPV1Yn1Tr3S3IBCeuyay5
01gEcF8kHa9HYaOdP9K0VsIGZod3/KSGy5pVNCEwmeykcXPVWvTps355ALVGZYVE
u9nzKNMss1rZpyb45ue7
=zTKO
-----END PGP SIGNATURE-----

--m8RPluiNA7RIyL8J--
