Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2AYLmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:42:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33109 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab2AYLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:42:13 -0500
Date: Wed, 25 Jan 2012 11:42:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap update for v3.3
Message-ID: <20120125114211.GE3687@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

for you to fetch changes up to 421e8d2de3bd8b089dc6322d8589b7eb38437a23:

  regmap: Reset cache status when reinitialsing the cache (2012-01-20 13:49:30 +0000)

----------------------------------------------------------------
A fairly simple bugfix for a WARN_ON() which was triggered in the cache
reset support as a result of some subsequent work.  There's only one
mainline user for the code path that's updated right now (wm8994) so
should be low risk.
----------------------------------------------------------------

Mark Brown (1):
      regmap: Reset cache status when reinitialsing the cache

 drivers/base/regmap/regmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH+qLAAoJEBus8iNuMP3dIAMP/i0LytwKUGP6LPhme7Y+D/0p
fL8x/3taH9LIgTwxUPbe4l7k91feaaqZNp54S+X1ysJmRrg9pybQT6aar1OWdcGN
K/PPqvFNjbW7z7xxs1/0p19R9Qag/jqDAh/38VK7rdQLkiL5Cx1ffASsP9yt/AQD
tQAYRIStPEEo+oc4hnAttRUmo3xoGM/smW9dawX43H7im3qnT5q+ijJq67uqClm4
Lnrh2oJMHkF1jFM4YC9sLVg7A15t17Xa5TWv8A720z8aFzmWxdBa4TlDtp5j/wFH
FnAzp5nejfvGzOW2V0A+bHhabp3DCNo9GeZetO2T5UeXkSl9xn/Ls6ZQ2ZNy/9SV
zWKvZauyh2/yVgmYTET6DlBtn1GfbTmI2fIsjhJ4XNzxzdbk9e2ZkbcCluwASkmv
TGZYHR7eFkWuus7Pt6AeO8Z0wCKZylzmoYOZ/LYnHJq0OW0nyTB15qWOMhN8ljCe
YAzy7RZgibiHuJpLugmczu62bcajHbMLkw3y48F6fv3r+K4Z9tfMHtqcnc5kIW7v
Q6k3HXLqsq2yZYdW69MpLGaOgKVBe8YiWDZord5y8chhx5jDOh6116JMWW7Uv7Xp
NlhXsPKmLNUdfafzDpXYbO4Uy8kH27V3fsTstsMX4QYEPjZuB8+prTPxuDThXR4h
Cqb5GMeOsyukxqbjES4w
=62+9
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
