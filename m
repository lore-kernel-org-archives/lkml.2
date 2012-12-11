Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2LKH6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:58:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2LKH6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:58:15 -0500
X-AuditID: cbfee61b-b7f616d00000319b-6b-50c6e795714e
Message-id: <1355212688.7291.151.camel@kjgkr>
Subject: [GIT PULL] f2fs: request for tree inclusion
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        f2fs-dev <linux-f2fs-devel@lists.sourceforge.net>, Ted <tytso@mit.edu>,
        Greg K-H <gregkh@linuxfoundation.org>, Arnd <arnd@arndb.de>
Date: Tue, 11 Dec 2012 16:58:08 +0900
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-6NTF17Tfv29ghZugX4tY"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfd2pz48FGHw4ZmaxZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJWx5U9CwT2LisnvNjE3MHZqdzFyckgImEgsa17CBmGL
	SVy4tx7I5uIQEljGKPHm6jNWmKKG03cZIRKLGCVW/14LVfWaUeL7p60sIFW8AroSbXf+M3cx
	cnAIA3Vsf1IHYrIJaEts3m8AUiEkoCjxdv9dsJkiAjoSF8+tAZvJLPCSUeLayt9gCRYBVYn2
	NS3MIDa/gKjEydZPjCA2s0CVxLXVS5ggDlKS2N3eyQ6xVlDix+R7LBC9AhLfJh9iAdkrISAr
	sekAM8h8CYFD7BJTlzWyQPRKShxccYNlAqPoLCRjZyEZBRHXlGjd/psdwtaWWLbwNTOEbSux
	bt17qBobiU1XFzBC2PIS29/OYV7AyL6KUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTGpHcw
	rmqwOMQowMGoxMOroXUsQIg1say4MvcQowrQnEcbVl9glGLJy89LVRLhLc0FSvOmJFZWpRbl
	xxeV5qQWH2JMBvp0IrOUaHI+MC3klcQbGhubmJmYmphbmpqbkiasJM7b7JESICSQnliSmp2a
	WpBaBLOFiYNTqoExU+K7zhrXh8Lr1q2KCDns/KTyVPaNFR6nosyPcmd9CSn+qphZ6Tw/3DAk
	i60j6ozlgZjUwMQJkn9OdljIHNQ8e2Dhle8M3+fbPHK+YLFgzeUr389LWW0XYJaVO2XOqnDe
	s/3Yk3M/mhUOO8/c+ZI9vyEhXFIlb8V85b/P/DhV33C+sNug6cSuxFKckWioxVxUnAgA45CG
	EgEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd2pz48FGDy+rWexZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYseVPQsE9i4rJ
	7zYxNzB2ancxcnJICJhINJy+ywhhi0lcuLeerYuRi0NIYBGjxOrfa6Gc14wS3z9tZQGp4hXQ
	lWi785+5i5GDQxioe/uTOhCTTUBbYvN+A5AKIQFFibf777KC2CICOhIXz61hBBnDLPCSUeLa
	yt9gCRYBVYn2NS3MIDa/gKjEydZPYEcwC1RJXFu9hAniICWJ3e2d7BBrBSV+TL7HMoGRfxaS
	sllIUhBxTYnW7b/ZIWxtiWULXzND2LYS69a9h6qxkdh0dQEjhC0vsf3tHOYFjOyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYIj+Jn0DsZVDRaHGAU4GJV4eDW0jgUIsSaWFVfmHmJUAZrz
	aMPqC4xSLHn5ealKIryluUBp3pTEyqrUovz4otKc1OJDjMlAX09klhJNzgcmnbySeENjEzMj
	SyMzCyMTc3PShJXEeZs9UgKEBNITS1KzU1MLUotgtjBxcEo1MDLKSoTb/Dy5O6e68Er58xOH
	QnfG/LJKjPFzUH+sdaNOjUNQ7HGYeT5LSUeBx++6DclfOZQMZjXUvLnF3tn4aWZRYlpy05LA
	LkNb8bzn97hYrf488XhSsN1qBcfdeNbTjHzZf/Yls6VWd9gfuZP1N+Wt2917UZJWC5StM/gW
	+TfcN8i413xDiaU4I9FQi7moOBEAGXYEdjADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6NTF17Tfv29ghZugX4tY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first pull request for tree inclusion of Flash-Friendly File
System (F2FS) towards the 3.8 merge window.

http://lwn.net/Articles/518718/
http://lwn.net/Articles/518988/
http://en.wikipedia.org/wiki/F2FS

The f2fs has been in the linux-next tree for a while, and several issues
have been cleared as described in the signed tag below.
And also, I've done testing f2fs successfully based on Linux 3.7 with
the following test scenarios.

- Reliability test:
  Run fsstress on an SSD partition.

- Robustness test:
  Conduct sudden-power-off and examine the fs consistency repeatedly,
  while running a reliability test.

So, please pull the f2fs filesystem.
If I'm missing any issues or made mistakes, please let me know.

Thanks,
Jaegeuk Kim

The following changes since commit
29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/for-3.8-merge

for you to fetch changes up to 6666e6aa9f36b2bfd6b30072c07b34f2a24becf1:

  f2fs: fix tracking parent inode number (2012-12-11 13:43:45 +0900)

----------------------------------------------------------------
Introduce a new file system, Flash-Friendly File System (F2FS), to Linux
3.8.

Highlights:
- Add initial f2fs source codes
- Fix an endian conversion bug
- Fix build failures on random configs
- Fix the power-off-recovery routine
- Minor cleanup, coding style, and typos patches
----------------------------------------------------------------
Greg Kroah-Hartman (1):
      f2fs: move proc files to debugfs

Huajun Li (1):
      f2fs: fix a typo in f2fs documentation

Jaegeuk Kim (22):
      f2fs: add document
      f2fs: add on-disk layout
      f2fs: add superblock and major in-memory structure
      f2fs: add super block operations
      f2fs: add checkpoint operations
      f2fs: add node operations
      f2fs: add segment operations
      f2fs: add file operations
      f2fs: add address space operations for data
      f2fs: add core inode operations
      f2fs: add inode operations for special inodes
      f2fs: add core directory operations
      f2fs: add xattr and acl functionalities
      f2fs: add garbage collection functions
      f2fs: add recovery routines for roll-forward
      f2fs: update Kconfig and Makefile
      f2fs: update the f2fs document
      f2fs: fix endian conversion bugs reported by sparse
      f2fs: adjust kernel coding style
      f2fs: resolve build failures
      f2fs: cleanup the f2fs_bio_alloc routine
      f2fs: fix tracking parent inode number

Namjae Jeon (10):
      f2fs: fix the compiler warning for uninitialized use of variable
      f2fs: show error in case of invalid mount arguments
      f2fs: remove unneeded memset from init_once
      f2fs: check read only condition before beginning write out
      f2fs: remove unneeded initialization
      f2fs: move error condition for mkdir at proper place
      f2fs: rewrite f2fs_bio_alloc to make it simpler
      f2fs: make use of GFP_F2FS_ZERO for setting gfp_mask
      f2fs: remove redundant call to f2fs_put_page in delete entry
      f2fs: introduce accessor to retrieve number of dentry slots

Sachin Kamat (1):
      f2fs: remove unneeded version.h header file from f2fs.h

Wei Yongjun (1):
      f2fs: remove unused variable

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/f2fs.txt |  421 +++++++++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/f2fs/Kconfig                    |   53 ++
 fs/f2fs/Makefile                   |    7 +
 fs/f2fs/acl.c                      |  414 +++++++++
 fs/f2fs/acl.h                      |   57 ++
 fs/f2fs/checkpoint.c               |  794 ++++++++++++++++
 fs/f2fs/data.c                     |  702 ++++++++++++++
 fs/f2fs/debug.c                    |  361 ++++++++
 fs/f2fs/dir.c                      |  672 ++++++++++++++
 fs/f2fs/f2fs.h                     | 1083 ++++++++++++++++++++++
 fs/f2fs/file.c                     |  636 +++++++++++++
 fs/f2fs/gc.c                       |  742 +++++++++++++++
 fs/f2fs/gc.h                       |  117 +++
 fs/f2fs/hash.c                     |   97 ++
 fs/f2fs/inode.c                    |  268 ++++++
 fs/f2fs/namei.c                    |  503 ++++++++++
 fs/f2fs/node.c                     | 1764
+++++++++++++++++++++++++++++++++++
 fs/f2fs/node.h                     |  353 +++++++
 fs/f2fs/recovery.c                 |  375 ++++++++
 fs/f2fs/segment.c                  | 1791
++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h                  |  618 +++++++++++++
 fs/f2fs/super.c                    |  657 +++++++++++++
 fs/f2fs/xattr.c                    |  440 +++++++++
 fs/f2fs/xattr.h                    |  145 +++
 include/linux/f2fs_fs.h            |  413 +++++++++
 include/uapi/linux/magic.h         |    1 +
 29 files changed, 13488 insertions(+)
 create mode 100644 Documentation/filesystems/f2fs.txt
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile
 create mode 100644 fs/f2fs/acl.c
 create mode 100644 fs/f2fs/acl.h
 create mode 100644 fs/f2fs/checkpoint.c
 create mode 100644 fs/f2fs/data.c
 create mode 100644 fs/f2fs/debug.c
 create mode 100644 fs/f2fs/dir.c
 create mode 100644 fs/f2fs/f2fs.h
 create mode 100644 fs/f2fs/file.c
 create mode 100644 fs/f2fs/gc.c
 create mode 100644 fs/f2fs/gc.h
 create mode 100644 fs/f2fs/hash.c
 create mode 100644 fs/f2fs/inode.c
 create mode 100644 fs/f2fs/namei.c
 create mode 100644 fs/f2fs/node.c
 create mode 100644 fs/f2fs/node.h
 create mode 100644 fs/f2fs/recovery.c
 create mode 100644 fs/f2fs/segment.c
 create mode 100644 fs/f2fs/segment.h
 create mode 100644 fs/f2fs/super.c
 create mode 100644 fs/f2fs/xattr.c
 create mode 100644 fs/f2fs/xattr.h
 create mode 100644 include/linux/f2fs_fs.h

--=20
Jaegeuk Kim
Samsung

--=-6NTF17Tfv29ghZugX4tY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQxueQAAoJEEAUqH6CSFDSsdsP+wX2qnhZ5mu8nsZ3zwRdGAyg
3uSXhpYYY9+YXWmqP5c+eHG3VOFKr9nR3rzhC6emFPN5hpOQ75jxJKc7OXwHS/nj
P8eMFuAkko9KFicMJ8K2cYSohop/uKY5m+txeFU5nDl5OwJJe7tcPcJ8LU8dHzEE
PC9nZj3Hj/iNKTOhIWaYUCBw0s1xZlTSMnZpaCebu5TeUV/GxW62f/awQlcSVM4W
YIyJRn4WCX+m1iBAoEA70ZFMAcKp4gswR2IPG2rfN1Caz+vNrcBsw1kw4tIFy9AM
UU9A02Sr4l1p5Jc1VRi8ZjI97qRBKLpcArTrUYQZpUaDfylY5IXjB8JhDmDwqX56
Ix+nsn9eZWSdOeURxku2Wwu8bAHz2AMoi+qNeWpS92pk1WsHKhWe4zQ3wdlvjaIE
yB683W0BanZEUi33yBj5C6Ga2YwWazxfLHz/xyXEJG78lqU+XmNcbC9+PErYHHJZ
3qvlc2iz/Jff8bWRqWC36aXNbwcZBRDs/fKH0se4u763a2QTr+L4XDVJjy9/FZs4
y84LfL53dxOfjQFLyUXzPP0bL9dxtsL5w2qT2WNSuojxi6TtSLwx5PFHmvvnyrZv
vW8469hPKrSpxPL2VPlxkOxy9ZZbvCHWidG2vyOdDBaENspcrXM/dgYR6MqJ1Ky1
JMAJNgWoDLoteGm6RB5w
=AxNN
-----END PGP SIGNATURE-----

--=-6NTF17Tfv29ghZugX4tY--

