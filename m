Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2GWIes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:34:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:32124 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab2GWIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:34:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="170063325"
Message-ID: <1343032747.4060.120.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.6-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Mon, 23 Jul 2012 11:39:07 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qOl0sND/2ZGeY7GOepGg"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qOl0sND/2ZGeY7GOepGg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit c6727932cfdb13501108b16c38463c09d5ec7a74=
:

  UBIFS: fix a bug in empty space fix-up (2012-07-20 10:13:27 +0300)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.6-rc1

for you to fetch changes up to 7074e5eb233343e4bad8c0a3f9e73167cf85a159:

  UBIFS: remove invalid reference to list iterator variable (2012-07-20 10:=
27:25 +0300)

----------------------------------------------------------------
* Added another debugfs knob for forcing UBIFS R/O mode without flushing ca=
ches
  or finishing commit or any other I/O operation. I've originally added thi=
s
  knob in order to reproduce the free space fixup bug (see c672793) on nand=
sim.
  Without this knob I would have to do real power-cuts, which would make
  debugging much harder. Then I've decided to keep this knob because it is =
also
  useful for UBIFS power-cut recovery end error-paths testing.
* Well-spotted fix from Julia. This bug did not cause real troubles for
  UBIFS, but nevertheless it could cause issues for someone trying to modif=
y
  the orphans handling code. Kudos to coccinelle!
* Minor cleanups.

----------------------------------------------------------------
Alexandre Pereira da Silva (1):
      UBIFS: fix compilation warning

Artem Bityutskiy (2):
      UBIFS: add debugfs knob to switch to R/O mode
      UBIFS: simplify reply code a bit

Julia Lawall (1):
      UBIFS: remove invalid reference to list iterator variable

 fs/ubifs/debug.c  |   11 +++++++++++
 fs/ubifs/debug.h  |    5 +++++
 fs/ubifs/dir.c    |    2 +-
 fs/ubifs/orphan.c |    4 ++--
 fs/ubifs/replay.c |   20 ++++++--------------
 5 files changed, 25 insertions(+), 17 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-qOl0sND/2ZGeY7GOepGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQDQ2rAAoJECmIfjd9wqK0Oo4QAIzIoY5De3hhVxmsC5dliSLY
3Z8LQL4okJGA/u2MWHU52eYCcheN1OSip4pzkMrQoGMWVDoz6k1BbfB//gnr0zor
uK7r96Dk2q34jodJ4YL1SWs3pwLKSKbkm2Iq+YQFKI8B9hSLYMXPAT1ntqYSwyb/
ruJvxeLfK/jene74KdBoI2PhwHgUAF79Qs/AWls6WQCaxg0FAJTAFeyNO31WbQVH
3J9GthT2Xtos8zUfLmzqcZr9RLT7VPjNdxLjeqFINNpNHmwg1mnYb/jgbg/w8nAI
lhxLfwZ+pEo+DQyTWf6IfsYlOGXiL9WJfNThWJouIt+cK/dNff9KYMnTUHv1GGXl
hwF8yMss9XpdIq8itu5+HCF8dr9iTYvY7qzyb15L3zLom4DX3C+po2LiRYISttWV
DeaDU2GhV2VRf3PRYFLcBxQVD2/B7HPqOv0kEIX0TW+fZEH1URsG3rH6x1LiI48B
9yebXmboYtagYqwmLFkLyyXBF3JuwNaPMPJwgYqf7fksXKiz0OLaFeSQPbsA/qLY
+3uDul/gJWs+o3kHyafp06537R0fAoqCOedNt7OK4LaW9xsxBCaYPBfMNHhdGO8U
rMPoG8usNWWRyBviZgNCbALaYzrsvNZj4sDBUddaDDSsrORVA19V4/sGJhy8ugoo
9eEeFUoiQGVMoI8nwLO8
=cg9k
-----END PGP SIGNATURE-----

--=-qOl0sND/2ZGeY7GOepGg--

