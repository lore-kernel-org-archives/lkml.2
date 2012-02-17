Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2BQAbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:31:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2BQAbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:31:32 -0500
Date: Thu, 16 Feb 2012 18:31:29 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.3-rc4
Message-ID: <20120217003128.GA20071@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c38e23456278e967f094b08247ffc3711b1029b2:

  i387: fix sense of sanity check (2012-02-15 08:05:18 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git ecryptfs-3.3-rc4-fixes

for you to fetch changes up to 465c9343c5b746ec2325a220fa3e50cc647d2db7:

  ecryptfs: remove the second argument of k[un]map_atomic() (2012-02-16 16:06:27 -0600)

----------------------------------------------------------------
Fixes maximum filename length and filesystem type reporting in statfs() calls
and also fixes stale inode mode bits on eCryptfs inodes after a POSIX ACL was
set on the lower filesystem's inode.

----------------------------------------------------------------
Cong Wang (1):
      ecryptfs: remove the second argument of k[un]map_atomic()

Tyler Hicks (2):
      eCryptfs: Improve statfs reporting
      eCryptfs: Copy up lower inode attrs after setting lower xattr

 fs/ecryptfs/crypto.c          |   68 ++++++++++++++++++++++++++++++++++++----
 fs/ecryptfs/ecryptfs_kernel.h |    6 +++
 fs/ecryptfs/inode.c           |    2 +
 fs/ecryptfs/keystore.c        |    9 ++---
 fs/ecryptfs/mmap.c            |    4 +-
 fs/ecryptfs/read_write.c      |    4 +-
 fs/ecryptfs/super.c           |   14 ++++++++-
 7 files changed, 89 insertions(+), 18 deletions(-)

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPPZ/gAAoJENaSAD2qAscK4EwP/jMw6V9QM0qQBaPte3v3paN2
XGUUAFdTCmOLdmgMSXre+1tOpCsTXmtIqoS++So05oEkNQL3Sd1et9RP7ferTwNG
CHhOMXF+cvbbnBPB1KIu3aL7zJHGq15X01fnXRWT7j9OoEcf3q+rCS1FzdpKyNNA
WzVU2lo/pkQSuUYkrkeCT4alJwNnLHlg0/RlCOTROq+yuwcCRrFOq4HqgDFAT5ZE
hYe6DUq+TN8atNPjmbvTqKF+XvfJ0RV8NWDS2l7RNTjuWUDOnRSKlEs0jpFuh7F0
CEI2NfaLTMzdLwxFvA3eXG5bBDGR8Rt7coPQqD1WKPwLrKxfpBzkaRfhlofUm5RE
z2iPZvvSrnVtHxuU8ZHP5xRNJeb/CYd5X7rsNPf+AXe8nRABQj56HB0wa2FDHMjM
C5CqLgONi8ASiwV86Tk4NRb8rXDdTh554P3tlgfOtYCheE6B2sj8uG4exrb8vouP
yLqkRyfeUYgTLJvpAmg2V6306GDZudtTve2jDGdYtZqxoPQoE89H9iOnHqQZklP7
ABvCZ2p71yukVIV5bWabP5ReebWxj5SQ8xKAoIROin59bw/4uJb7EzkHtxbGZk+j
cs2vaWWjUjO9VP15eU+MAT/YOpaqsXKt+xJqL9Xbmb+EZls5z1x5kDwqnjFek1EF
S2UdIa0O3BhDwXtSIBYB
=yCXF
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
