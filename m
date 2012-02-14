Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2BNWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:11:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932388Ab2BNWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:11:37 -0500
Date: Tue, 14 Feb 2012 14:11:33 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator fixes for 3.3
Message-ID: <20120214221132.GA4035@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

for you to fetch changes up to 9fc886a1880766fb91cb27c2e96bd814cef640d6:

  regulator: Fix getting voltage in max8649_enable_time() (2012-02-10 11:20:55 +0000)

----------------------------------------------------------------
One small bug fix from Axel plus a fix for a build failure in unrealstic
but commonly built configs which for some reason manage to survive for
an awfully long time in -next without any reports.
----------------------------------------------------------------

Axel Lin (1):
      regulator: Fix getting voltage in max8649_enable_time()

David Miller (1):
      regulator: Fix mc13xxx regulator modular build (again)

 drivers/regulator/max8649.c                |    2 +-
 drivers/regulator/mc13xxx-regulator-core.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOtuvAAoJEBus8iNuMP3dLsoP/3mwOmghVYEu1ikK/dpotf4L
vZeOc7+tHmg288IOwabkwuucz6ORqVCmC+jVotGUqmOyFSZzEPSnZRI3XGtEejzj
vLIQRf9dPRp+YktAVoz96AYhAq4RoMATMaKBDkOCeBjutO8XVuBnQurXfZeqzWFs
7CzaRSt/FOe0L3jG1vwGy8aoMwssADg3J5JUBfkLIYr+VfI+YuRhqnoUObArtZvD
0iR5osKFc+lzMXAx4p07eI+Cx6pPbLpNYpeO3NNEazRVcoTOKOPtDbXpipk+jHLm
PpD9arI2k+xvFh4fdRI1Cd8GgOeb2ahuKgQtzi0rMspz7bsbLFDP7FkubDvweFe/
oLa/KjQtQladlbgFQLzr8ABTl0iOjc2Vrkxc1gF16jh084rpaCGFhf3M6mdqIrNB
gy3+ecy4V8SpvJP5GjsF7b2cGEVC9TOr8vZ+UsFgmb0lWWMKG1GyIGSC4vV6tN52
GneDfS/84U+877LGpb4jGLY2xihQe15EtJRGK61Q3lUlk90+xUGnS4wJntTueH3L
JC0mUpspZ4rreIF9QO63LbnaSR5tY+7i/eh19bPaDThJzSQMwXHu+o0UMLvtQLrS
H229fD7hfpyDYz379ix60DiFMPnGgfQuFb7ZfGtF7DfaUDCKVUioKUp4UIaWD0jH
6anwpD/lJkkVWjS6XDSE
=BMr+
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
