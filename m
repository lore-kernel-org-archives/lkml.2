Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162124Ab2CSQ2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:28:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22615 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161566Ab2CSQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:28:01 -0400
Date: Mon, 19 Mar 2012 12:23:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, dan.magenheimer@oracle.com
Subject: [GIT PULL] (cleancache) stable/for-linus-3.4
Message-ID: <20120319162345.GA24647@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F675E90.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable/for-linus-3.4

which has some patches for the cleancache API that should have been
submitted a _long_ time ago. They are basically cleanups:
 - rename of flush to invalidate
 - moving reporting of statistics into debugfs
 - use __read_mostly as necessary.

Oh, and also the MAINTAINERS file change. The files (except the
MAINTAINERS file) have been in #linux-next for months now. The late
addition of MAINTAINERS file is a brain-fart on my side - didn't realize
I needed that just until I was typing this up - and I based that patch
on v3.3 - so the tree is on top of v3.3.

Please pull!


 .../ABI/testing/sysfs-kernel-mm-cleancache         |   11 --
 Documentation/vm/cleancache.txt                    |   41 ++++----
 MAINTAINERS                                        |    7 ++
 drivers/staging/zcache/zcache-main.c               |   10 +-
 drivers/xen/tmem.c                                 |   10 +-
 fs/block_dev.c                                     |    2 +-
 fs/super.c                                         |    2 +-
 include/linux/cleancache.h                         |   24 +++---
 mm/cleancache.c                                    |   98 ++++++++------------
 mm/filemap.c                                       |    2 +-
 mm/truncate.c                                      |   10 +-
 11 files changed, 96 insertions(+), 121 deletions(-)

Dan Magenheimer (4):
      mm: cleancache: s/flush/invalidate/
      mm: zcache/tmem/cleancache: s/flush/invalidate/
      mm: cleancache: report statistics via debugfs instead of sysfs.
      mm: cleancache: Use __read_mostly as appropiate.

Konrad Rzeszutek Wilk (2):
      MAINTAINERS: Adding cleancache API to the list.
      Merge branch 'stable/cleancache.v13' into linux-next


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPZ12NAAoJEFjIrFwIi8fJYQwIALW/8Q8lOUYi5MPMjKhNYUAa
JDOgX3aO3Ngi7ixwW0EqemSdS3zhu6AEkFcSUE9WCd1n38U4uez/CoQRxmKON3n8
L5iQY17a4RPahM8LgirkZUwySBl+plEgUGZV769vaK9F6YUwnpTIo5EALimUtZHS
L3191NBduegLbJVcOZgEliI0zmsGhClF/dhpQxCbkYnexyPEYNDyowNmrRe4GpMM
cig75XORQuVZzlxQsQ0faLB3FJOots0a6eSSnGaz8h06rNndx1fYeO/tEY/58bwq
o1pf5U3LzR7CRTF0QffOrz23+FBlyftmzOH7MhNGHuU5hiqbW/sMggJoADOrWgg=
=zlGh
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
