Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2LOXTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 18:19:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50325 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2LOXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 18:19:17 -0500
Message-ID: <1355613547.2376.7.camel@kjgkr>
Subject: Re: [GIT PULL] f2fs: request for tree inclusion
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        f2fs-dev <linux-f2fs-devel@lists.sourceforge.net>, tytso@mit.edu,
        gregkh@linuxfoundation.org, arnd@arndb.de
Date: Sun, 16 Dec 2012 08:19:07 +0900
In-Reply-To: <1355212688.7291.151.camel@kjgkr>
References: <1355212688.7291.151.camel@kjgkr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jUc4OXKAViIEz4Nd5gCm"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jUc4OXKAViIEz4Nd5gCm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I'm seeing that f2fs has not been merged yet.
Could you give me any notice for this?
Management priority, or something else?

BTW, I have added a couple of bug fixes since "for-3.8-merge".
Which is better sending between [GIT PULL v2] or additional pull request
after merge?

Thanks,
Jaegeuk Kim

2012-12-11 (=ED=99=94), 16:58 +0900, Jaegeuk Kim:
> Hi Linus,
>=20
> This is the first pull request for tree inclusion of Flash-Friendly File
> System (F2FS) towards the 3.8 merge window.
>=20
> http://lwn.net/Articles/518718/
> http://lwn.net/Articles/518988/
> http://en.wikipedia.org/wiki/F2FS
>=20
> The f2fs has been in the linux-next tree for a while, and several issues
> have been cleared as described in the signed tag below.
> And also, I've done testing f2fs successfully based on Linux 3.7 with
> the following test scenarios.
>=20
> - Reliability test:
>   Run fsstress on an SSD partition.
>=20
> - Robustness test:
>   Conduct sudden-power-off and examine the fs consistency repeatedly,
>   while running a reliability test.
>=20
> So, please pull the f2fs filesystem.
> If I'm missing any issues or made mistakes, please let me know.
>=20
> Thanks,
> Jaegeuk Kim
>=20
> The following changes since commit
> 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:
>=20
>   Linux 3.7 (2012-12-10 19:30:57 -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
> tags/for-3.8-merge
>=20
> for you to fetch changes up to 6666e6aa9f36b2bfd6b30072c07b34f2a24becf1:
>=20
>   f2fs: fix tracking parent inode number (2012-12-11 13:43:45 +0900)
>=20
> ----------------------------------------------------------------
> Introduce a new file system, Flash-Friendly File System (F2FS), to Linux
> 3.8.
>=20
> Highlights:
> - Add initial f2fs source codes
> - Fix an endian conversion bug
> - Fix build failures on random configs
> - Fix the power-off-recovery routine
> - Minor cleanup, coding style, and typos patches
> ----------------------------------------------------------------
> Greg Kroah-Hartman (1):
>       f2fs: move proc files to debugfs
>=20
> Huajun Li (1):
>       f2fs: fix a typo in f2fs documentation
>=20
> Jaegeuk Kim (22):
>       f2fs: add document
>       f2fs: add on-disk layout
>       f2fs: add superblock and major in-memory structure
>       f2fs: add super block operations
>       f2fs: add checkpoint operations
>       f2fs: add node operations
>       f2fs: add segment operations
>       f2fs: add file operations
>       f2fs: add address space operations for data
>       f2fs: add core inode operations
>       f2fs: add inode operations for special inodes
>       f2fs: add core directory operations
>       f2fs: add xattr and acl functionalities
>       f2fs: add garbage collection functions
>       f2fs: add recovery routines for roll-forward
>       f2fs: update Kconfig and Makefile
>       f2fs: update the f2fs document
>       f2fs: fix endian conversion bugs reported by sparse
>       f2fs: adjust kernel coding style
>       f2fs: resolve build failures
>       f2fs: cleanup the f2fs_bio_alloc routine
>       f2fs: fix tracking parent inode number
>=20
> Namjae Jeon (10):
>       f2fs: fix the compiler warning for uninitialized use of variable
>       f2fs: show error in case of invalid mount arguments
>       f2fs: remove unneeded memset from init_once
>       f2fs: check read only condition before beginning write out
>       f2fs: remove unneeded initialization
>       f2fs: move error condition for mkdir at proper place
>       f2fs: rewrite f2fs_bio_alloc to make it simpler
>       f2fs: make use of GFP_F2FS_ZERO for setting gfp_mask
>       f2fs: remove redundant call to f2fs_put_page in delete entry
>       f2fs: introduce accessor to retrieve number of dentry slots
>=20
> Sachin Kamat (1):
>       f2fs: remove unneeded version.h header file from f2fs.h
>=20
> Wei Yongjun (1):
>       f2fs: remove unused variable
>=20
>  Documentation/filesystems/00-INDEX |    2 +
>  Documentation/filesystems/f2fs.txt |  421 +++++++++
>  fs/Kconfig                         |    1 +
>  fs/Makefile                        |    1 +
>  fs/f2fs/Kconfig                    |   53 ++
>  fs/f2fs/Makefile                   |    7 +
>  fs/f2fs/acl.c                      |  414 +++++++++
>  fs/f2fs/acl.h                      |   57 ++
>  fs/f2fs/checkpoint.c               |  794 ++++++++++++++++
>  fs/f2fs/data.c                     |  702 ++++++++++++++
>  fs/f2fs/debug.c                    |  361 ++++++++
>  fs/f2fs/dir.c                      |  672 ++++++++++++++
>  fs/f2fs/f2fs.h                     | 1083 ++++++++++++++++++++++
>  fs/f2fs/file.c                     |  636 +++++++++++++
>  fs/f2fs/gc.c                       |  742 +++++++++++++++
>  fs/f2fs/gc.h                       |  117 +++
>  fs/f2fs/hash.c                     |   97 ++
>  fs/f2fs/inode.c                    |  268 ++++++
>  fs/f2fs/namei.c                    |  503 ++++++++++
>  fs/f2fs/node.c                     | 1764
> +++++++++++++++++++++++++++++++++++
>  fs/f2fs/node.h                     |  353 +++++++
>  fs/f2fs/recovery.c                 |  375 ++++++++
>  fs/f2fs/segment.c                  | 1791
> ++++++++++++++++++++++++++++++++++++
>  fs/f2fs/segment.h                  |  618 +++++++++++++
>  fs/f2fs/super.c                    |  657 +++++++++++++
>  fs/f2fs/xattr.c                    |  440 +++++++++
>  fs/f2fs/xattr.h                    |  145 +++
>  include/linux/f2fs_fs.h            |  413 +++++++++
>  include/uapi/linux/magic.h         |    1 +
>  29 files changed, 13488 insertions(+)
>  create mode 100644 Documentation/filesystems/f2fs.txt
>  create mode 100644 fs/f2fs/Kconfig
>  create mode 100644 fs/f2fs/Makefile
>  create mode 100644 fs/f2fs/acl.c
>  create mode 100644 fs/f2fs/acl.h
>  create mode 100644 fs/f2fs/checkpoint.c
>  create mode 100644 fs/f2fs/data.c
>  create mode 100644 fs/f2fs/debug.c
>  create mode 100644 fs/f2fs/dir.c
>  create mode 100644 fs/f2fs/f2fs.h
>  create mode 100644 fs/f2fs/file.c
>  create mode 100644 fs/f2fs/gc.c
>  create mode 100644 fs/f2fs/gc.h
>  create mode 100644 fs/f2fs/hash.c
>  create mode 100644 fs/f2fs/inode.c
>  create mode 100644 fs/f2fs/namei.c
>  create mode 100644 fs/f2fs/node.c
>  create mode 100644 fs/f2fs/node.h
>  create mode 100644 fs/f2fs/recovery.c
>  create mode 100644 fs/f2fs/segment.c
>  create mode 100644 fs/f2fs/segment.h
>  create mode 100644 fs/f2fs/super.c
>  create mode 100644 fs/f2fs/xattr.c
>  create mode 100644 fs/f2fs/xattr.h
>  create mode 100644 include/linux/f2fs_fs.h
>=20

--=20
Jaegeuk Kim
Samsung

--=-jUc4OXKAViIEz4Nd5gCm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQzQVrAAoJEEAUqH6CSFDS+qMP/Atx2phiw78/lwufb8SHQv0N
Q8kavZFOSOHCYhseSQDnW73qJ3M3nhm7PCvQT2KE7LNAu4ZNeVdlxZuB8g0KXpa8
6ekEpaENaPBe6G8ltZ7oQkcgg/Yd2xPgkOX84eTNoysM5aukYxBe8ynpyusTHmvo
MAu9SFH8DFb57RmQzz/uV3PaA7X8bzI7/dUuZArXcwR7bZ1J9wUc8sCTv5DW/M6O
4YZdlcdQY0TIzS8AgACsLxbc2vzBQxOkK7f1pQ13DMSG1olV5JavuMDZ3pNaxKiO
2ohDV8vdFNC+t5WQX6M4qew5fLer2L+YnyMURQsHyKzu+zmYjhF9SIp6loVUudeM
2Q1Y5AbB7RDk4d961Blxbv1qBKR7Q/9kQ1RpFxuDyx4Bqf6CW1YLrbv0Iow2iZ/r
Zv2CyX3GNAu6sT85WYGkkw/eypqem/FASR+rgEqNhSHrTYi83zqlopwvD/1JGNRG
TZBL4iQx+SG1jpaBHRTIXczN5pxSn0PAzdUsgGfvR0EFNIC7qPE61wHBZ5TIDbwo
dX5Gh+XlNnN7szImo9QOmI46I50oOa4MllH1kty4AIuf2xEDXXuv3B+hjCNuXWDG
d/rJ25f3G/i0gzoyz9w66Ie7dq0sTs/XJeoQRdA+hPmSy/+8oNtsgTI4TuFZGjRi
jBUC04o8bdM2YTInmHpe
=8d9e
-----END PGP SIGNATURE-----

--=-jUc4OXKAViIEz4Nd5gCm--

