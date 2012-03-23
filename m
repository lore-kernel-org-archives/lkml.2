Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2CWNhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:37:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:46984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2CWNhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="132404734"
Message-ID: <1332510012.18717.64.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for v3.4-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Date: Fri, 23 Mar 2012 15:40:12 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-d1XjdgSWa4I4Oi0eKjGD"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d1XjdgSWa4I4Oi0eKjGD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit
6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.4-rc1

for you to fetch changes up to cc831464f839dc2559f896b96d13eaa0366282b0:

  UBI: rename MOVE_CANCEL_BITFLIPS to MOVE_TARGET_BITFLIPS (2012-03-09
10:31:18 +0200)

----------------------------------------------------------------
- Reduce memory consumption
- Fix picking unknown blocks
- Fix error-path in 'ubi_scan()'
- Minor clean-ups

----------------------------------------------------------------
Artem Bityutskiy (4):
      UBI: fix documentation and improve readability
      UBI: fix eraseblock picking criteria
      UBI: rename peb_buf1 to peb_buf
      UBI: rename MOVE_CANCEL_BITFLIPS to MOVE_TARGET_BITFLIPS

Josselin Costanzi (1):
      UBI: reduce memory consumption

Richard Weinberger (1):
      UBI: fix error handling in ubi_scan()

 drivers/mtd/ubi/build.c |   14 ++++----------
 drivers/mtd/ubi/eba.c   |   30 +++++++++++++++---------------
 drivers/mtd/ubi/io.c    |   14 +++++++-------
 drivers/mtd/ubi/scan.c  |   16 ++++++++--------
 drivers/mtd/ubi/ubi.h   |   12 +++++-------
 drivers/mtd/ubi/wl.c    |   21 ++++++++++-----------
 6 files changed, 49 insertions(+), 58 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-d1XjdgSWa4I4Oi0eKjGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPbH08AAoJECmIfjd9wqK0g1sQAKJXq6dNRmxx/IX7V5AqiBRB
0q/gHUqYeAAP66trb1S1OfNzmTTF7UUVyYl1PZ+gNmXIwFqSc1m86rgeYYXdYqql
ne/muGYK1PpEJlHsMukdrIQdIE9mirsziPusC1ItpGBtHYBvqaIjCqi8RPb3plHD
tu4MyRcCbn3P4V5Zf/Zbe4DswBYC7qrUNSAgQLXEx0tehqkG7aRthfmh7fGjIAE1
4gN2T/zx4grwp73bZJAhhxQfPC9gKRStg/ZtthjHX5D9Tc6IihGq81HoDVFB4bD2
Qq7MZuRsaukaCkEFDL7+gB1uDhRaD9p5MUYoLXh7lMwmyaXP063/FjjIE+dEQODf
ZmDmVgBSM8AZO6eRuzVntCJY94ILGnoDvfvro9o+JwVYAybbbhOw1N1gvVJW8Jil
iPJ+ygH4+sVptTlsKBYWHMiTVUhi/02oYMWHROqIfGIVuD2yCxDeKIWhLAUyMSAM
4aEXJR/UzIes98OQgvhFGGHNFGeDmEJCzvqoZ/JCZaQ714wtLNzE/JrCNx6fQRTz
mtyiq3rI6yDbTDSoLfsUZRStwL8JdfseuSA+Dsin1eoGXU1BsinUr1SuoHshsNyk
1WSFIEipqpyRGo3k0gxmQ+jgTdJZUhgbaogavrRsMw0Dx1GCKFXtAO7H1ra8ABof
fLj6Em4gwt0cBAq0yJkT
=LnFS
-----END PGP SIGNATURE-----

--=-d1XjdgSWa4I4Oi0eKjGD--

