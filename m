Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2KGK6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab2KGK6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:58:46 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k4+KRJKJ5SOmj3F1Edtq"
Organization: Red Hat UK Ltd
Date: Wed, 07 Nov 2012 10:58:09 +0000
Message-ID: <1352285889.2729.12.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k4+KRJKJ5SOmj3F1Edtq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following GFS2 fixes,

Steve.

---------------------------------------------------------------------------=
--------

Here are a number of GFS2 bug fixes. There are three from Andy Price
which fix various issues spotted by automated code analysis. There are two
from Lukas Czerner fixing my mistaken assumptions as to how FITRIM
should work. Finally Ben Marzinski has fixed a bug relating to mmap and
atime and also a bug relating to a locking issue in the transaction code.


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37=
:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Andrew Price (3):
      GFS2: Fix an unchecked error from gfs2_rs_alloc
      GFS2: Fix possible null pointer deref in gfs2_rs_alloc
      GFS2: Clean up some unused assignments

Benjamin Marzinski (2):
      GFS2: Don't call file_accessed() with a shared glock
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Lukas Czerner (2):
      GFS2: Require user to provide argument for FITRIM
      GFS2: Fix FITRIM argument handling

 fs/gfs2/file.c  |   14 +++++---------
 fs/gfs2/lops.c  |   16 ++--------------
 fs/gfs2/quota.c |    7 +++++--
 fs/gfs2/rgrp.c  |   33 +++++++++++++++++++++------------
 fs/gfs2/super.c |    3 ++-
 fs/gfs2/trans.c |    8 ++++++++
 6 files changed, 43 insertions(+), 38 deletions(-)


--=-k4+KRJKJ5SOmj3F1Edtq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQmj68AAoJEMrg3m4a/8jS5EIP/RvYGsyvP2KlOzQTPdBfb7EL
xVOZW1Sk4eJv7YCtJ+sdtaZQbEBS3d1Sj8MPwDQvlNV3QNjzit0PdmaLG0nX4Ry+
ODwcQUQESsTmkgFDkM/WqcrPueBbQ7VUmEm4aKnsC+bFuq2yAEt9zQ485kY7sXRo
yAh2PmX0LdWDI54UzoZIA5Z7hQvjY46TENQRy5YUQtmNteL6oektlRQn6XrbfPww
OlKOPxtn0bbTLsYhWB5YkYkCxDb4Fmgn1wCP16w1EG0VSU+cLvryipouPciS/CEy
DlomfUKekSohMiz5c8DqRmFsjfqHL1+3oBkPTPwSpDq03WhjsRvCzU2r1q0rwDPC
bX9uzEx++EOA4m7zaQDjELj1deA/hVjTxT0n4XqXO4MnW3GLackInScavR8NKNEf
xddczIoLtOuO5NEqesYylp7TmCzWpipsny3pc1aTGB4bD1KYGTSkTwfDYpnQlexh
Bsr8xPpISF1JCzVJqwhPcH3riv/Ps8GD6+QqudVHtHbytYL4ORK5Cd3OkJiaHQCR
T8oyUrv9HFfM+HK/Aue4SKf4S1Pcb6wehM5qBvJvin3iEu98uuMn+dGlBSCWkTry
3MkWPJ578bD450XtFddm6aSEoKTNCSZkL1pN8De+coRuJM9ewS4Ag1QrDFpZ78FG
/Z61EeBXooFLoTagkzt4
=2V8t
-----END PGP SIGNATURE-----

--=-k4+KRJKJ5SOmj3F1Edtq--

