Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3ABSmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:42:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3ABSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:42:28 -0500
Date: Wed, 2 Jan 2013 10:42:22 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.8-rc2
Message-ID: <20130102184221.GB20946@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 0e4a43ed08e2f44aa7b96aa95d0a540d675483e1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes (2012-11-07 13:38:56 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.8-rc2-fixes

for you to fetch changes up to 37028758f92d0a3eb74bcfbecf6bc477072e9e28:

  fs/ecryptfs/crypto.c: make ecryptfs_encode_for_filename() static (2012-12-18 10:10:13 -0600)

----------------------------------------------------------------
Two self-explanatory fixes and a third patch which improves performance. When
overwriting a full page in the eCryptfs page cache, skip reading in and
decrypting the corresponding lower page.

----------------------------------------------------------------
Cong Ding (1):
      fs/ecryptfs/crypto.c: make ecryptfs_encode_for_filename() static

Li Wang (1):
      eCryptfs: Avoid unnecessary disk read and data decryption during writing

Wei Yongjun (1):
      eCryptfs: fix to use list_for_each_entry_safe() when delete items

 fs/ecryptfs/crypto.c  |    2 +-
 fs/ecryptfs/kthread.c |    6 +++---
 fs/ecryptfs/mmap.c    |   12 ++++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQ5H+NAAoJENaSAD2qAscKEg8QALXF1I5ekbVw2kOarFQASUi3
rnb9yDpGs6ysP39PYRm4ISALgl1g211OAb5uHalJ4rirx8XUlgoT+KDYghlZHRXp
04wBngoTLu3Iwb21VToMUSHyLj1UPUK4o82v5fljn2JaMe116Ih77OTmqwikdgC/
aNqY8DmmBuYMvVXHYwl5z0Bow+PkWhSFAwzgZtzgao63xHqsrNdjmk4FkGrTOF/C
IWFmsr9ysYhV+LOcVpiT7Uq8NBWGmRM1/V9H4LIGlKYOl1L0Uizh4EzvtOkZAU8/
ahd1Zs323WGBR7lYLho5/EsYSfZ5MFaWbzvEE/JW/Qlxy/9b0CBnJ1DkkyzUrPLA
OOM1DEa4NVe3Sw8ZHpGh+wUDb9m6Ofaly5Jn9c+gk9diXNsN2agm+3+0a9JUShwf
wjgpRJa1sHt5B5UqIYJhodEV7ADKuGAuNuBQw5iEgBtcCy//ZM2ydMXvZAQhOsgU
L0DiWiZfVlE2mmbf2pt+ncZBxUUW0z0PIQ0ZxGbm3ubfA0+VKmgTtUNseOffuyrA
iY2xLBIOl5mLoIv4tTRKY3SxWL5hLAQie7AYD4/gh/hoy1RE2Sk9FnpBsmpIRQPE
7ydWi2p4nXZwdFN/0t3qFj25ymOOdB8yUzwidnqTw5LWN90ukaHyTMXn5aPNkDvC
4il9Ye7ZORXm1bymqNIU
=TdRs
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
