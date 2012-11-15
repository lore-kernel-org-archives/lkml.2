Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab2KOE1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:27:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57817 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993129Ab2KOEMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:14 -0500
Date: Thu, 15 Nov 2012 13:12:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator fixes for 3.7
Message-ID: <20121115041206.GD7599@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.7

for you to fetch changes up to ecb48c337b1814aefa9f8b33f4ee93d0ab955902:

  Merge remote-tracking branches 'regulator/fix/gpio', 'regulator/fix/put' and 'regulator/fix/supp-volt' into tmp (2012-11-15 11:16:02 +0900)

----------------------------------------------------------------

regulator: Fixes for v3.7

A few fixes for teardown issues that will be rarely seen, plus a fix for
a silly bug in regulator_is_supported_voltage() which shows how often
the answer to the question should be false.

The supported voltage commit is very new as I just edited to add a Cc to
stable, the code itself has been in -next.

----------------------------------------------------------------
Andrew Lunn (1):
      Regulator: core: Unregister when gpio request fails.

Charles Keepax (1):
      regulator: core: Avoid deadlock when regulator_register fails

Marek Szyprowski (1):
      regulator: fix voltage check in regulator_is_supported_voltage()

Mark Brown (1):
      Merge remote-tracking branches 'regulator/fix/gpio', 'regulator/fix/put' and 'regulator/fix/supp-volt' into tmp

 drivers/regulator/core.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpGuIAAoJELSic+t+oim9ibwP+gKehneNyLL/ciJwJHvZf7dK
UTJx26FqpAZySgQe73ZZJbcIKh33ZuTtqO39kxAOFeCbeUiFQqCVFQc8e/AUJGUQ
3sKb63C15QHQXSBCJFkPBfyY12VGGQB0leFqvOJChG8GUaxiinWqo9ly0K9YzDgR
KMIWaxxUc+LchHezTTl3U+OCcypa+2WG3Yy4eukIrxpEAIiLHePBX7zwaKs8MVQ/
WxfosLso0WWJKIVhk1SoYNRg+Vlbru2I6x6Oh1KCSPMeyG5I2nMKZYf7Kn/bs0Kd
ZTrnIxNfAA67BjK9xQZaZ0P7k4wI9+SkoVoJPhFZUwxxUuwo5tWG1wOyfzgf8OR+
ZCDgVzIOvkFsfxmdql8oje35s6GhH7+gkJ22qerUmS0tSsZv9PYl5U9gJHa5SFlG
z0Qur0i2sVf6NzB8Wnz/H0QfEpAnWQU0MzFKhLmoXAgdoWHfsfILNnXrxIP9aRFV
VjjwGHV5xmkn0Q6F06NkwuUcL0U8C2sVDJLXGEZlHwiIFoypqo+T9FghL5s3y8Kl
n2DumuxwXqzY6ttuc4efxigTACwzUOsJk1bPOfuerw1fWbLslbVbWUpH4QLAmQHX
Lyx07DcoZmw6FuREBtpdKe5Yk065NrzgovuONffFNnSNmnXY9t7uLTCg7UcyqffH
ElbvwbAxzL7StlWpEA9b
=4sjq
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
