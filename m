Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2FYJLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:11:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46552 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab2FYJLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:11:49 -0400
Date: Mon, 25 Jun 2012 10:11:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for 3.5
Message-ID: <20120625091141.GE4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xKAOFH8xvSgM/GoA"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xKAOFH8xvSgM/GoA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ea851f4f08eb366e829abb8f1b2f1741a19ed696:

  regulator: Change db8500-prcmu match names to reflect Device Tree (2012-06-17 18:27:49 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.5

for you to fetch changes up to a68de074613abd028b2ce63366d18db9c29e15d2:

  regulator: palmas: fix regmap offsets for enable/disable (2012-06-23 11:37:28 +0100)

----------------------------------------------------------------
regulator: Fixes for 3.5

A few small, driver specific bug fixes, nothing exciting here but all
needed if you happen to be using the affected hardware.
----------------------------------------------------------------

Axel Lin (2):
      regulator: tps65023: Fix mask for LDOs output voltage select control
      regulator: tps6524x: Fix get_voltage_sel for fixed voltage

Graeme Gregory (1):
      regulator: palmas: fix regmap offsets for enable/disable

 drivers/regulator/palmas-regulator.c   |    7 +++++--
 drivers/regulator/tps65023-regulator.c |    2 +-
 drivers/regulator/tps6524x-regulator.c |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

--xKAOFH8xvSgM/GoA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6CtBAAoJEBus8iNuMP3djRsP/ROp81N6e3kco5bFHQRUyBoI
gbj47woc2uhE+zTqzK+p95DIc2H974tyT/a3gksDj4I5P9dbvKbtUWbjTvOSHj5p
TygNsI7WatZ5fOs9xiOajmnStUq9sA6jDfdr4zlwzEqK72aQWrOMFSrqg1qFMDWq
nkr872z326lHU1vDfPh5yruPWdJc1OFbGoWb48axJpQVNGv69bnikoH8EVDBmMAv
YRQBxlLeRuGZI+riUFwuv3ZwQF/x2wEnGIgodZw+ejS0qUAjWeioWJkbKpWBd842
AWdGuSBDpqt3uM/l1c5IXLIj68aiTQssa9vBroDMOqd5zNZE/95VWijreBoN8rEb
xfsxI92TIvjEdKNLPcrOaiEflvzmcegqxxNT3AQdCiV/IR/2IJtI+4LgTVuwXPvy
OTc3LZOabcQM98Ul3VuKQO5sqmCJr2AGDTLSjYRGfh7kroml+Z5QFydH6sbvEw1r
wFtPVYbcmOkG0saa8vecy03on2wJeOtkpzhdmjXx36lz9iStDwANjR0lHcMmwnXs
/vIESV6AfEBucvKQ9g3H7oZ8R1nqgXtk/cGBhcIRZyYLB++XOehtyKjVMKnnLhQV
HAutI+0f9eT9Ug7D4LSe4xIFkE6A+4KOTr4s79WY3npzUodmph2WgU9pMEU0kVmD
88qirKkIxxgjgjyt2xpK
=dgoJ
-----END PGP SIGNATURE-----

--xKAOFH8xvSgM/GoA--
