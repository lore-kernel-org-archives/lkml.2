Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab2B1Ls5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:48:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab2B1Ls4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:48:56 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WidLXBh4B9Tdh18CvzGj"
Organization: Red Hat UK Ltd
Date: Tue, 28 Feb 2012 11:49:32 +0000
Message-ID: <1330429772.2753.11.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WidLXBh4B9Tdh18CvzGj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following bug fixes,

Steve.
---------------------------------------------------------------------------=
-

The following changes since commit 586c6e7013c8cbb8c91aaa6568ec349b1dc2c691=
:

  Merge tag 'ktest-fix-make-min-failed-build-for-real' of git://git.kernel.=
org/pub/scm/linux/kernel/git/rostedt/linux-ktest (2012-02-27 15:43:05 -0800=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Bob Peterson (2):
      GFS2: Read in rindex if necessary during unlink
      GFS2: Ensure rindex is uptodate for fallocate

Steven Whitehouse (2):
      GFS2: Fix race between lru_list and glock ref count
      GFS2: Read resource groups on mount

 fs/gfs2/glock.c      |   14 ++++++++++----
 fs/gfs2/inode.c      |    5 +----
 fs/gfs2/ops_fstype.c |    5 +++++
 fs/gfs2/rgrp.c       |   13 +++++++++----
 4 files changed, 25 insertions(+), 12 deletions(-)


--=-WidLXBh4B9Tdh18CvzGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPTL8qAAoJEMrg3m4a/8jS3NMP/3v0j8bAM8kodiVBFi0aEjW6
tFl+BHAaDjLM725Sana7+0n83YkbsjGVlszDGzulN3e9jnnzR9XfToiiiwD75GtZ
vEkdBvi+SaNaujfvHJ+ppXANt/yIWZpoBtOlyqxpU/5IJGiDeyTxPSp0C11UgPvY
TAr3cnf5tuG44bjYCaO55fvpc+lXPiUVi42VydABFfcgmujAphVmQZl+akMHrcCL
YTkP3b8lnoEXWdemjfixVJRykSqLaFuawRWn+bDBNHSuQWKTjt/6xL82oAx10u2X
sdUSoqk1kICNnPw9CASAujSHjZVzSnj2pj8qL8vJ1Mihjca/nEOElhhAQLq4cyMs
k74F4UsNZRK6pl+CPl66aeupqTSbHGMaEx576WCiQuw2wrD5nS8MqTJz+vUOmXaO
/zXvCZZnj8BQeGTGlp0C7PSet9XYiz40P8E4R05m7DVLrXPKjxwxc28VxpipsjnY
hLElm6oiLsKl0J3yKGJlx5LsGwm+RsrT9YnL2VejkFqv1hIlDKFMen+YNtQ4jPyh
UPBjwT763akSjD8tZcHN0TQegU+iYS8W+H8z1C4+uI2oqEqd4C6q9xJVi1ndWQgc
PI8TMumBaRfet+WntCAGecKGP3rz/I4KGQYrnb9nghJ5DXDIIvN/H+PQls3JiJ26
rS5RUfcAR1MQ8yavTX85
=iNxw
-----END PGP SIGNATURE-----

--=-WidLXBh4B9Tdh18CvzGj--

