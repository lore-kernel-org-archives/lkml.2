Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab2CTQJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab2CTQJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:09:53 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2y9w08IycFTcdTC0Lkob"
Organization: Red Hat UK Ltd
Date: Tue, 20 Mar 2012 16:10:09 +0000
Message-ID: <1332259809.2764.52.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2y9w08IycFTcdTC0Lkob
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes. The only change since
the initial patch posting is a three line bug fix from Bob Peterson,

Steve.

---------------------------------------------------------------------------=
---
The following changes since commit 891003abb0db6bfffd61b76ad0ed39bb7c3db8e1=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes =
(2012-02-28 09:17:31 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Benjamin Marzinski (1):
      GFS2: call gfs2_write_alloc_required for each chunk

Bob Peterson (5):
      GFS2: Sort the ordered write list
      GFS2: Unlock rindex mutex on glock error
      GFS2: Eliminate sd_rindex_mutex
      GFS2: make sure rgrps are up to date in func gfs2_blk2rgrpd
      GFS2: Change truncate page allocation to be GFP_NOFS

Steven Whitehouse (7):
      GFS2: glock statistics gathering
      GFS2: Move two functions from log.c to lops.c
      GFS2: FITRIM ioctl support
      GFS2: Make bd_cmp() static
      GFS2: Flush pending glock work when evicting an inode
      GFS2: Remove a __GFP_NOFAIL allocation
      GFS2: Clean up log flush header writing

 fs/gfs2/bmap.c              |    4 +-
 fs/gfs2/file.c              |   15 ++-
 fs/gfs2/glock.c             |  210 +++++++++++++++++++++++++++++++++++--
 fs/gfs2/incore.h            |   50 ++++++++-
 fs/gfs2/inode.c             |    4 +-
 fs/gfs2/lock_dlm.c          |  123 +++++++++++++++++++++-
 fs/gfs2/log.c               |  244 +++++++++++++++------------------------=
----
 fs/gfs2/log.h               |    5 +-
 fs/gfs2/lops.c              |   95 +++++++++++++++++-
 fs/gfs2/main.c              |   18 +++
 fs/gfs2/ops_fstype.c        |    9 ++-
 fs/gfs2/quota.c             |    2 +-
 fs/gfs2/rgrp.c              |  189 ++++++++++++++++++++++++++--------
 fs/gfs2/rgrp.h              |   10 +-
 fs/gfs2/super.c             |    3 +-
 fs/gfs2/trace_gfs2.h        |   60 +++++++++++-
 fs/gfs2/util.c              |    1 +
 fs/gfs2/util.h              |    3 +
 fs/gfs2/xattr.c             |    4 +-
 include/linux/gfs2_ondisk.h |    1 +
 20 files changed, 805 insertions(+), 245 deletions(-)


--=-2y9w08IycFTcdTC0Lkob
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPaKvTAAoJEMrg3m4a/8jSxXEP/ii321s0VbpPv9SEaKq9rAaW
cjrjYLq9JVW0F8kzgoLD58eVEo8Jc8X/XUI5WUr88nBsMFQ2wMw0HyBOtAwv0sKJ
6WvzypOxoAUVHuZ6Dk8pEd9s3wMadaLFaxrQl4bdfTAX8SuwgmPMInw3xsPo073C
d3c/TBfZz3nqqEoYJiAW861hBP+5IAOdUDMuFSvK248+1vgDpMwJPzxJ5JWi4kuq
C0ybtG6rKSUTvMOg/Ue5tVQpU36CZZNX5EjuDfQytyA0YFqYM/H/JuGuS82ImGsy
FX9UWZJkOWnyHkUF7gL+wZQOU7pqopkJcM0ZX6RDridCdlT76aJdfn9tE8k6u1wq
mGXyyHsTcH/GXaryNt1wtrtaQGRuFPCE7WC3sTEXQyuRvxtpMkeDjbYzPZdDU4Z0
isSOKexnAA/Mpd0mvdsTm5Q3oTor1qNgp+D+PiNe+I1znN5NE1xrjciy1+TAcbku
kDd/tcR6S4gyoSoVeBgEiQ3rgMsh11nSHGWAgpIiKvKxFt+mbYB+qcEP38wAcqGk
R1/y/4civDr6TLemIW+dIaQfqtppMaIyKAvxfYWqDlwGcgoteADnUQfcSZMK9lCp
kGQUW/frWwSqxLvKErQzA1OZW5w0ltkAHxsdvCn80b68rkEyb9LcqtAHZp2Bn7Xo
pxz/MX1EN8MBw3fSBgwN
=vRQ8
-----END PGP SIGNATURE-----

--=-2y9w08IycFTcdTC0Lkob--

