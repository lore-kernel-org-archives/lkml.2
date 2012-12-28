Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2L1Crq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 21:47:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30251 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2L1Crm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 21:47:42 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3a-50dd0848436e
Message-id: <1356662843.9202.12.camel@kjgkr>
Subject: [GIT PULL v2] f2fs fixes for 3.8-rc2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        sedat.dilek@gmail.com
Date: Fri, 28 Dec 2012 11:47:23 +0900
In-reply-to: <1356662069.9202.6.camel@kjgkr>
References: <1356659666.9202.4.camel@kjgkr>
 <CA+icZUWXMJ9oEgNDsJ=syBn8MmLL=hVhBKUqUs=GM4ZMHrgQaA@mail.gmail.com>
 <1356662069.9202.6.camel@kjgkr>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-0aW4idU7qCmyihgfGbvp"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zga4Hx90Ag//fWSz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLa9p9gLzioWHHyyjmmBsYX0l2MnBwSAiYS3SeOsUDY
	YhIX7q1nA7GFBJYxSqz+pAlTs+fTZ6AaLqD4dEaJU8/WsUE4rxklHjbOZe9i5ODgFdCR+PMu
	CaRBWEBXYuaqy6wgYTYBbYnN+w0gZipKvN1/lxXEFhEwkvj84goryBhmgcVMEuu+toAdwSKg
	KrF2z1JGEJsTaOS+1ytZIJqnMEp8mRQHYvMLiEqcbP0EVsMsUCXx98xXVohDlSR2t3eyg9i8
	AoISPybfg5opIPFt8iEWkHskBGQlNh1ghih/xC7x/4glhC0pcXDFDZYJjOKzkEydhWQSRFxT
	onX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0tsfzuHeQEj+ypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2MkIiU2sG4ssHiEKMAB6MSD+/CnjsBQqyJZcWVuYcYVYDmPNqw+gKjFEte
	fl6qkgiv/g+gNG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDk0heSbyhsbGJmYmpibmlqbkp
	acJK4rzNHikBQgLpiSWp2ampBalFMFuYODilGhiXpKStm7pc+tL66HC/UnWHAu5J0S8C2o0f
	T5vDdrpp0T6nRVeV3M11Nktca/t4ZEYVt3aL8hG++0cUdDV1z2/2OfWRy1+q6HOjCfv2gl9y
	He8PqDorbF4U73G2trOh6ItFwCeeD50zbRcdv+xms/LcbE+uicYdBqLzjWfV8rIHuq04YVJ4
	bpsSS3FGoqEWc1FxIgBtCOHaGAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQV13jrsBBs9nW1ns2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtO0/wV5wULHi
	5JVzTA2ML6S7GDk5JARMJPZ8+swCYYtJXLi3nq2LkYtDSGA6o8SpZ+ugnNeMEg8b57J3MXJw
	8AroSPx5lwTSICygKzFz1WVWkDCbgLbE5v0GIGEhAUWJt/vvsoLYIgJGEp9fXGEFGcMssJhJ
	Yt3XFrBlLAKqEmv3LGUEsTmBRu57vZIFonkKo8SXSXEgNr+AqMTJ1k9gNcwCVRJ/z3xlhThU
	SWJ3eyc7iM0rICjxY/I9lgmMgrOQlM1CkoKIa0q0bv/NDmFrSyxb+JoZwraVWLfuPVSNjcSm
	qwsYIWx5ie1v5zAvYGRfxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc88+kdjCubLA4xCjA
	wajEw7uw506AEGtiWXFl7iFGFaA5jzasvsAoxZKXn5eqJMKr/wMozZuSWFmVWpQfX1Sak1p8
	iDEZGBoTmaVEk/OBaSqvJN7Q2MTMyNLIzMLIxNycNGElcd5mj5QAIYH0xJLU7NTUgtQimC1M
	HJxSDYxLcjfor/l2VtR3y9n8T96rg+w/qV1w1OU9cbRkm0SVfFuAKOv2zR+7mt5yB9xpdFqk
	EKbdeOalg/W2fy98hH+cvzKDZ05Dbs6DM9P8Jn2/bWVh9jGIz+AED8OOj0LGmcHLeSeUv7V6
	zfr9Rd1Et8rjhvVcO65uUmrLNdj/UMfZ+qSA8L3/h24osRRnJBpqMRcVJwIAhoc02EkDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0aW4idU7qCmyihgfGbvp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Sorry for the noise.
I've resolved the S-O-B issue in v1 tree.
Here is the pull request v2.
Thanks,

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

for you to fetch changes up to 9836b8b9499cb25ea32cad9fff640eef874c5431:

  f2fs: unify string length declarations and usage (2012-12-28 11:27:53
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


--=-0aW4idU7qCmyihgfGbvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ3Qg7AAoJEEAUqH6CSFDSSD4P/AsOAbbDfRLNzMniMfgAlTLW
nBz7d/7mAPxQ1ytFhbz0jgnhusFpLpEmforXtR2dzOJaFYmqj3LqaQw27Yhuxmom
PBGpsEK+BK0FsYb06oIX4in/q3Dbh11Z5iiWk3MdG8Hhg0iqQyXvvmhvk7ZjMqeB
H6GrmYaUSQtN8Y6iE7K0Y2sH3w8KCH7pZ97kGDBckIUaHtuvj1t5zb+D6NU2KAZd
3cptVYzSZcWJRCcEdC14Kd63Twauymm/5Ui3NT+Cq32lNY8ynlXJOCwzHCxSlzEw
uhbwmW7o8CVSB7TQpM5xBQkteWI9U/uJZ4RbDLOejmMqNDIiENJOLWHja3AWmXSd
EnLxb0Bz1q8/70Mpa/iPmFlzNZbcVncV4AHu/mI90Uu4gGufUCctnOKboTO5HU7p
HimafYNsz3ukuoc7JB01VJlG4gu7SI334lNcL8G9KDLmfqh8+ag9eqfygZGfv+gS
Aug+sHSspbg4bQEQXP7TvpPoKq/9pFche9I8Z07i+hNqYgU/1pm6vYqmLQlgO2Xh
sp/0Cq6QbFmnwm2M+hdGfGdMO4WYlg9f13oBZWE8XPsge1uQw/RMvZRIBaK7UQHM
nCcHsKGHZYbtddaxKl1yL91IuwJo64RhTno422GsOAuaNGOyd+HPLOjogWhOZlN9
fkcVQUEtHyBpO98hqStn
=2BmY
-----END PGP SIGNATURE-----

--=-0aW4idU7qCmyihgfGbvp--

