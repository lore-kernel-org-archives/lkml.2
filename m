Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2IMNnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2IMNnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:43:13 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fUuWdjq5D6AcyAuZCK4/"
Organization: Red Hat UK Ltd
Date: Thu, 13 Sep 2012 14:42:24 +0100
Message-ID: <1347543744.2719.5.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fUuWdjq5D6AcyAuZCK4/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following GFS2 fixes....

Steve.

--------------------------------------------------------------------------

Here are three GFS2 fixes for the current kernel tree. These are all
related to the block reservation code which was added at the merge
window. That code will be getting an update at the forthcoming merge
window too. In the mean time though there are a few smaller issues
which should be fixed.

The first patch resolves an issue with write sizes of greater than
32 bits with the size hinting code. The second ensures that the
allocation data structure is initialised when using xattrs and the
third takes into account allocations which may have been made by
other nodes which affect a reservation on the local node.

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee=
:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Steven Whitehouse (3):
      GFS2: Make write size hinting code common
      GFS2: Fix missing allocation data for set/remove xattr
      GFS2: Take account of blockages when using reserved blocks

 fs/gfs2/file.c  |   31 ++++++++++++++++++++++---
 fs/gfs2/inode.c |    8 +++++-
 fs/gfs2/rgrp.c  |   66 +++++++++++++++++++++++----------------------------=
---
 3 files changed, 61 insertions(+), 44 deletions(-)


--=-fUuWdjq5D6AcyAuZCK4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUeK8AAoJEMrg3m4a/8jS4jsQAIef2atAxozr2ocASX4WAkrC
RbGo2HLTGMkrdfOiCCYrpXMWeR98uJXVRTZwjRoxokx/sRVegYble37rgLm13UTF
VN6vEjCobH2H2U3F1lEcVhYVfymz2McLynu+6cM2cbCXI7OedDKNcEroau9A8uti
KHC2Zd6HZtYPjy0L38GgYqy0gHIwm2iANCbEeHtymNkUizZNcQIHglRgTWDfuQh3
+D8L8sFzhsUaD/D/1o70ge9rJGdWYvax9wkQu+KHx490m00vH8z6p5G6UxfvrPk9
GqI5mahgx1CBNxxBr4FoW+5pLldVXXuw4WRK5phiJ7a4mEe7NjlpKTYFqnTH/AAD
g0PZYcHT/nw0qVwquhW87sNsPz7vdCg92q5legZNN65/gpKGpTOB+NcDi04zBiTC
Fn/0GxKJfuy2X/g5NfdKr+D6b57Bj7/oR27BZ1mDpuPekEcWEYbaqO40UHTQ3hvS
3OWk6UU3UIAYE1G+LfhRGTGEozh+vLsWL4/Hf60ECufMZx5na7hLcCUqc8jjuSyC
KAlwU7MXq9KyFTQz+4PzvM1WY+Y1RprtVEW4qpyHBKjE93n6RBoksB9aPlS6nYU8
ml9JLY/0+KE+M3qM+IYcF8SD3MjXxM7eyuVDyMHjMRAvWwyMocbtbROeJ8RqK/bW
0GS+WUE6xaCYcv09fPeO
=yL6C
-----END PGP SIGNATURE-----

--=-fUuWdjq5D6AcyAuZCK4/--

