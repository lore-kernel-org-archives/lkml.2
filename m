Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2GFW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:27:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GFW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:27:20 -0400
Date: Fri, 6 Jul 2012 17:27:15 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.5-rc6
Message-ID: <20120706222714.GA30388@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit ff826b2b5b269ad440afa686ede879ccabfda387:

  Merge tag 'sound-3.5' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2012-07-03 11:10:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.5-rc6-fixes

for you to fetch changes up to 8dc6780587c99286c0d3de747a2946a76989414a:

  eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files (2012-07-06 15:51:12 -0500)

----------------------------------------------------------------
Fixes an incorrect access mode check when preparing to open a file in the lower
filesystem. This isn't an urgent fix, but it is simple and the check was
obviously incorrect.

Also fixes a couple important bugs in the eCryptfs miscdev interface. These
changes are low risk due to the small number of users that use the miscdev
interface. I was able to keep the changes minimal and I have some cleaner, more
complete changes queued up for the next merge window that will build on these
patches.

----------------------------------------------------------------
Tyler Hicks (3):
      eCryptfs: Properly check for O_RDONLY flag before doing privileged open
      eCryptfs: Fix lockdep warning in miscdev operations
      eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files

 fs/ecryptfs/kthread.c |    2 +-
 fs/ecryptfs/miscdev.c |   48 +++++++++++++++++++++++++++++-------------------
 2 files changed, 30 insertions(+), 20 deletions(-)

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJP92ZCAAoJENaSAD2qAscKIpQP/RG9TMzi1muYHYQkTkicHmkv
fn576OuE6Apaur/k2+nyna0vfL4hJ4yaehN0jIJjB2/o+Nq6QhNEtegFtJzAmPeZ
pQDGO/QkIH2AUaksCGEheVbtILguB7xGmNrOFTTCs460JVI+U48m5P8cam0twLkr
ECGYlWUF0UApeS3sTupZC3cxeTJRbgQ5IUXRilSmb+mnu2d2sS1ar/zJsRyDkTWV
NcpMEEQKoquhRNbuVB7hGNOYCYYGPYVmX1yHGBIkPI0a5T2XE4FfKBRYRkXavwmN
ObggUKzP3RroT8pBq1SjDgoXSUXfrPBotjseeI3qcMZvqBJz0al96xZKMzSRL7G7
yLe+p8jfiZbkRmfb8mHCtMybidP707fGWEEwU2roisOWoEO3FH0fsPpNqJd/UjXl
jMwIRRYL6Bp2csmPQD9XM1igtZb/UuPDmOFwMqOacfcbokM5btr11TPRodKMEKtQ
9NLz8wM7AqCAUZD/cfjX0GbU7ELVCY7mU4cX3mafQShpeLp3D5RktHsjdafUXR5e
TTz4qUdVBBQ9mDprISvaPsS9sD6LN6yL18FsEIZe736UwDqdaITC56/EtPwiMzJj
FBly+iD+8b45d/a/CZYf1ibBmL6vcaNNDRqvxspTw1U9KnVrhEn0EG41Q5TxSYr2
AOXIRhSnS0coP99ITJHc
=ShJS
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
