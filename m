Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2L1Byo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:54:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21056 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2L1Byk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:54:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-62-50dcfbde9c19
Message-id: <1356659666.9202.4.camel@kjgkr>
Subject: [GIT PULL] f2fs fixes for 3.8-rc2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Fri, 28 Dec 2012 10:54:26 +0900
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-XgkMdBp9WrZ70p0tjHEP"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zI917v+8EGOz6q2GxZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUx+fFHpoLtihXbdsk0MD6R7mLk5JAQMJHY/eYsI4Qt
	JnHh3nq2LkYuDiGBZYwSFz5cZIIpWjhtDztEYjqjxPb351khnNeMEqtPfQdyODh4BbQldv3w
	BzGFBbQkbn0vBjHZgKKb9xuAjBESUJR4u/8uK4gtImAk8fnFFbApzAKnGCWWf/jFDJJgEVCV
	OLHsNFgRv4CoxMnWT2DHMQtUSfyde4QF4h4lid3tnewgNq+AoMSPyfdYIHoFJL5NPsQCsldC
	QFZi0wFmkPkSAofYJWZduQ7VKylxcMUNlgmMorOQjJ2FZBREXFOidftvdghbW2LZwtfMELat
	xLp176FqbCQ2XV3ACGHLS2x/O4d5ASP7KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQCJPe
	wbiqweIQowAHoxIP76KeOwFCrIllxZW5hxhVgOY82rD6AqMUS15+XqqSCK/+D6A0b0piZVVq
	UX58UWlOavEhxmSgTycyS4km5wOTQl5JvKGxsYmZiamJuaWpuSlpwkrivM0eKQFCAumJJanZ
	qakFqUUwW5g4OKUaGFk3yOc71y2oX6O7TqNWuOfpjcZKhkc+M7suLZZU2haZWc4icTMjXMHo
	sGSas22M2CKpk9c9v93KtAlbuqZgedRqloWfg2YcOrKm7O3XfxP5jCdM2vK8J04qiaHu27ll
	hpwnlh8tfnwmQ+rC4ilznomtiP+kE5rw/sZ7jXA5JsbLbCf/af0zv67EUpyRaKjFXFScCADa
	OqBOAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd17v+8EGOydqmyxZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMfnxR6aC7YoV
	23bJNDA+ke5i5OSQEDCRWDhtDzuELSZx4d56ti5GLg4hgemMEtvfn2eFcF4zSqw+9R3I4eDg
	FdCW2PXDH8QUFtCSuPW9GMRkA4pu3m8AMkZIQFHi7f67rCC2iICRxOcXV8CmMAucYpRY/uEX
	M0iCRUBV4sSy02BF/AKiEidbPzGC2MwCVRJ/5x5hgbhHSWJ3eyfYbbwCghI/Jt9jmcDIPwtJ
	2SwkKYi4pkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMHx+0x6B+OqBotDjAIcjEo8vIt67gQIsSaWFVfmHmJUAZrz
	aMPqC4xSLHn5ealKIrz6P4DSvCmJlVWpRfnxRaU5qcWHGJOBvp7ILCWanA9MOXkl8YbGJmZG
	lkZmFkYm5uakCSuJ8zZ7pAQICaQnlqRmp6YWpBbBbGHi4JRqYIzycGb22mWekMzAMP2T+ldm
	l+OSwRz9Jrblb9Oz/u469f9uNe/i95d+f9Z7tnFG7Q++gJte8nXLNVT7EiR9rzyc8+lzlqtM
	zSd76/OpdxZHmW8tuck6vXfZngPKWWl5B7LSV8jpbIxOkrVSXtOfxHxv2XRvx6+Lm9S3Hhda
	ySKZ8rWXxeRxohJLcUaioRZzUXEiAI8YkqUvAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XgkMdBp9WrZ70p0tjHEP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following patches for bug fixes on the f2fs file system.
Thank you very much.

--=20
Jaegeuk Kim
Samsung

The following changes since commit
637704cbc95c02d18741b4a6e7a5d2397f8b28ce:

  Merge branch 'i2c-embedded/for-next' of
git://git.pengutronix.de/git/wsa/linux (2012-12-23 09:48:33 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/for-linus

for you to fetch changes up to 782c92d129775840cf9c1ad334f0722df9c76dc0:

  f2fs: unify string length declarations and usage (2012-12-28 09:57:55
+0900)

----------------------------------------------------------------
f2fs: bug fixes for 3.8-rc2

This patch-set includes two major bug fixes:
- incorrect IUsed provided by *df -i*, and
- lookup failure of parent inodes in corner cases.

[Other Bug Fixes]
- Fix error handling routines
- Trigger recovery process correctly
- Resolve build failures due to missing header files

[Etc]
- Add a MAINTAINERS entry for f2fs
- Fix and clean up variables, functions, and equations
- Avoid warnings during compilation

----------------------------------------------------------------
Geert Uytterhoeven (1):
      f2fs: add missing #include <linux/prefetch.h>

Jaegeuk Kim (11):
      f2fs: remove set_page_dirty for atomic f2fs_end_io_write
      f2fs: fix wrong calculation on f_files in statfs
      f2fs: fix handling errors got by f2fs_write_inode
      f2fs: should recover orphan and fsync data
      f2fs: do f2fs_balance_fs in front of dir operations
      f2fs: invalidate the node page if allocation is failed
      f2fs: return a default value for non-void function
      f2fs: add MAINTAINERS entry
      f2fs: fix equation of has_not_enough_free_secs()
      f2fs: clean up the start_bidx_of_node function
      f2fs: clean up unused variables and return values

Leon Romanovsky (1):
      f2fs: unify string length declarations and usage

Namjae Jeon (5):
      f2fs: fix up f2fs_get_parent issue to retrieve correct parent
inode number
      f2fs: handle error from f2fs_iget_nowait
      f2fs: remove unneeded initialization of nr_dirty in
dirty_seglist_info
      f2fs: fix fsync_inode list addition logic and avoid invalid access
to memory
      f2fs: remove unneeded variable from f2fs_sync_fs

 MAINTAINERS        | 10 ++++++++++
 fs/f2fs/data.c     |  1 +
 fs/f2fs/dir.c      | 16 +++++++++-------
 fs/f2fs/f2fs.h     |  2 +-
 fs/f2fs/file.c     | 10 ++++++----
 fs/f2fs/gc.c       | 34 +++++++++++-----------------------
 fs/f2fs/hash.c     | 18 +++++++++++-------
 fs/f2fs/inode.c    |  1 +
 fs/f2fs/namei.c    | 34 +++++++++++++++++-----------------
 fs/f2fs/node.c     | 37 ++++++++++++++-----------------------
 fs/f2fs/recovery.c | 10 +++++++---
 fs/f2fs/segment.c  | 46 ++++++----------------------------------------
 fs/f2fs/segment.h  | 15 ++++++++++++++-
 fs/f2fs/super.c    | 15 ++++++---------
 fs/f2fs/xattr.c    |  5 +++--
 15 files changed, 117 insertions(+), 137 deletions(-)


--=-XgkMdBp9WrZ70p0tjHEP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ3PvSAAoJEEAUqH6CSFDSUOUP/1TCkYkxA9GR1FPdcMbpXAQP
op50QR30M70AfuxOXja+2vSTTvmGNdwys73UuFsKN/h3zL4ioA+RP2ghAQbIoIH/
88ky2JsDDdJvUhQDZu84SaWQF1uxIdOnJcxSkec2+x8Ix+QJu8gAkdRP6r4iByY+
P/zUHC8/TlXu0/3TpcQpt79uUq8OeScFN/OVQIkGGvXVLHzjJ/J8BYqjjHhw7j/0
DPOrdp7OKK4YUyvi+u9BGewv+cYYVKEyZHJ8M0dXRE+oQNtgOcbKaD5mTr9bQ+qy
vHNGf83JufnHcNBVO1Qgo0sj5EoP4oML0QXbqtNSrmzVdHy2IflUH1trvrRyAA9k
aJPM2+sDG6OBBNMjLzFAM2sD59x/nUw+x/Hcj72yNuPt02ZJxC49DkfE4EGiZ+4V
XR4YPKUWzNhbWEq6OhOFH2ohLBn8btbX47sguxY5ZmpOLZgUKRdUeOoUqN1FqTvq
/JQS+iDPpC5Os3u+EVBDWcUg5DtQQfuEduUD4KqHH3rOwtwoqndU2x6iASrNiDX8
Eg0tnWoWZCbRPrQJMVqjnGzeeUBQXcjLlAHrXzQcVMcj+0gQYduRYK0k7GXqy24Q
hQSOrT6NseTy220qyZBzROORMj7o6Z/gzMXs/A00aaSAsvI8Fgz+V3YO1SzE3eM+
u8pi+dvjrVxXQdjJncKY
=zoTx
-----END PGP SIGNATURE-----

--=-XgkMdBp9WrZ70p0tjHEP--

