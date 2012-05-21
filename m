Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2EUISq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2EUISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:18:44 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nW7k/ZaXP01zc3hskgdG"
Organization: Red Hat UK Ltd
Date: Mon, 21 May 2012 09:17:46 +0100
Message-ID: <1337588266.2714.5.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nW7k/ZaXP01zc3hskgdG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following patches. There have been no changes s=
ince
they were posted for review,

Steve.

---------------------------------------------------------------------------=
-
The following changes since commit af3a3ab2966112c0d0a44df7eeb1e95fe32d4495=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes =
(2012-04-24 08:22:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Andrew Price (1):
      GFS2: Remove unused argument from gfs2_internal_read

Bob Peterson (14):
      GFS2: Rename function gfs2_close to gfs2_release
      GFS2: make function gfs2_page_add_databufs static
      GFS2: Use slab for block reservation memory
      GFS2: Eliminate offset parameter to gfs2_setbit
      GFS2: Fix function parameter comments in rgrp.c
      GFS2: Change variable blk to biblk
      GFS2: Use variable rather than qa to determine if unstuff necessary
      GFS2: Eliminate needless parameter from function gfs2_setbit
      GFS2: Eliminate vestigial sd_log_le_rg
      GFS2: eliminate log elements and simplify
      GFS2: Remove redundant metadata block type check
      GFS2: Eliminate unused "new" parameter to gfs2_meta_indirect_buffer
      GFS2: Add rgrp information to block_alloc trace point
      GFS2: Fix quota adjustment return code

Steven Whitehouse (9):
      GFS2: Drop "pull" argument from log_write_header()
      GFS2: Make gfs2_log_fake_buf() write the buffer too
      GFS2: Clean up log write code path
      GFS2: Remove duplicate log code
      GFS2: Remove bd_list_tr
      GFS2: Log code fixes
      GFS2: Fix sgid propagation when using ACLs
      GFS2: Update main gfs2 doc
      GFS2: Update glock doc to add new stats info

 Documentation/filesystems/gfs2-glocks.txt |  119 +++++++-
 Documentation/filesystems/gfs2.txt        |    9 +-
 fs/gfs2/acl.c                             |   12 +-
 fs/gfs2/aops.c                            |   18 +-
 fs/gfs2/bmap.c                            |   10 +-
 fs/gfs2/file.c                            |   12 +-
 fs/gfs2/glops.c                           |    6 -
 fs/gfs2/incore.h                          |   26 +-
 fs/gfs2/inode.h                           |    3 -
 fs/gfs2/log.c                             |  103 ++-----
 fs/gfs2/log.h                             |    2 -
 fs/gfs2/lops.c                            |  520 ++++++++++++++++---------=
----
 fs/gfs2/lops.h                            |   14 +-
 fs/gfs2/main.c                            |   26 +-
 fs/gfs2/meta_io.c                         |   28 +-
 fs/gfs2/meta_io.h                         |    4 +-
 fs/gfs2/ops_fstype.c                      |    1 -
 fs/gfs2/quota.c                           |    6 +-
 fs/gfs2/rgrp.c                            |  102 +++---
 fs/gfs2/trace_gfs2.h                      |   16 +-
 fs/gfs2/trans.c                           |   44 ++-
 fs/gfs2/util.c                            |    3 +-
 fs/gfs2/util.h                            |    3 +-
 23 files changed, 588 insertions(+), 499 deletions(-)


--=-nW7k/ZaXP01zc3hskgdG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPufomAAoJEMrg3m4a/8jSUvAP/2vNlV5TbaqYk+KouvoECio3
QsnNdpBQwxJsxMJaQeFuaY7itu9prhgD4khShPrlo6U3diaYQx3ll00gpgoI95dR
B4mxEsDxq376OBpyvwXxvhvt5f5r5cQxDx/W/8h3UCjXI17BU6MFcVgF+nFj9/EI
XQ9WJ0MIHABfSyxQNlBODdmotTe4fFi/uWM1T45QPPHpXOdnBXYxt0+DjlvqCwbH
PZazYDxPN26ZuQtqpL+rfI0HhlWeO9NNkWbPlZI5b53M88+Js/2GwhDQaw+hPocA
wk3E1EYIyJlxFBKTvPgMAeiEhkPRV+hgiHI2t0odAUi7j4Ll7MNE/0Eit6Z2IIjN
rFPxXTSD/Qj9bdHL3lkuBMSLpZaHob9jFovi2ic2p9Qt4J2zuh/+eBsIng5wEX1E
o0OmUIKAgmcST76VLLql5fSHjKrAdZcBUrh82qmPdocR+649TSMK9V41Fb8OeETy
7B6TYVo4ihv02FChcsOms6UQmw9qjkjzSCkxJvgwEn1ujTb2Dzc7lrOIIMon6XYr
1NHEMDgmou6lAv/Tt1GWlmCrHQxwByIC/CjJSR4vLmTGeMQNBuld5Bt586CrzBjg
ywFOmu6wTqkN0UBFdEjPyA1lM6DnMixMVZcvI7tRzI654vdgvPp1uuDazY8LksJa
qvNR0VxnQMwv8TJG9+fM
=8dnK
-----END PGP SIGNATURE-----

--=-nW7k/ZaXP01zc3hskgdG--

