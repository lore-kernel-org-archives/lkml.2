Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2DKKVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab2DKKVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:21:34 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RmCYZL6QoUoX025nrna8"
Organization: Red Hat UK Ltd
Date: Wed, 11 Apr 2012 11:21:36 +0100
Message-ID: <1334139696.2713.18.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RmCYZL6QoUoX025nrna8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[Apologies - I don't think the first message got signed as
 it should have. Here is a second attempt...]

Hi,

Please consider pulling the following patches,

Steve.

---------------------------------------------------------------------------=
---
The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928=
:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Benjamin Poirier (1):
      GFS2: use depends instead of select in kconfig

Bob Peterson (3):
      GFS2: put glock reference in error patch of read_rindex_entry
      GFS2: Make sure rindex is uptodate before starting transactions
      GFS2: Allow caching of rindex glock

 fs/gfs2/Kconfig |    7 ++-----
 fs/gfs2/aops.c  |    4 ++--
 fs/gfs2/bmap.c  |    6 +++++-
 fs/gfs2/dir.c   |    4 ++++
 fs/gfs2/inode.c |   13 +++++++++++--
 fs/gfs2/rgrp.c  |    8 +++++---
 fs/gfs2/xattr.c |   12 ++++++++++++
 7 files changed, 41 insertions(+), 13 deletions(-)



--=-RmCYZL6QoUoX025nrna8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPhVssAAoJEMrg3m4a/8jSwzEQAIpTuWJXFi02Qoek2aByzjvp
F1ZelDEpETeBKJU59GzVQokTn4CXi1EPnq62TWjORxTk7cRWUuCVvFeE8JE3FlQc
IaOOfZ8qM8u2pqzXZ+eegZcjYYPsO7jJInQOAswehteFCOZ8Uex3MYbGUQ2KNQA6
0gTZNot2CW071l4IddnIh6ieGAA6zOKePpzlbuxpy1IEGTc2uWqa7GPHvy9L53oU
IND05TMFXGRNARJYQh0dPGIjNfOcm4oxObBBsFAPC9j2Fi5Nv3Q1HwSnZ8Ogg8+o
WE3RW08My0t0U7OgIBo93xdvIS8OTIesiOXCNsEWmD5yrTPDB4F4c/Rk76G5zfPc
+Zi/d+70uAvL9zTZaCF+SB7wa3fM2JSZknahpBK/ZTSMvwbdI5sT7hmpPnxn2eDG
TxIu0L6xw416auKn8hjg8C9gmIKKH2GiBesDYmapcdlKZHRIoGHXbSa+j83Thmd5
CnjU6WUZTYMTRCmwuWSBylhuA6dO02GhImFntM17RvbiseOJUucFsuqfJgxaRtVd
BM/9lS6JA79fj2f5C59jphJ9VnhrxVzBF/iDcXBhAjXMWqBqXUjI/lO4hXngpEIe
WnNqhC38oZ/KE+OPQZqaDN0T/kJ3BJjQyjOdYBLZjee/RKMlCB9en6WK07iiMESa
tW5ws0zWuT490KNBdwCB
=qaPF
-----END PGP SIGNATURE-----

--=-RmCYZL6QoUoX025nrna8--

