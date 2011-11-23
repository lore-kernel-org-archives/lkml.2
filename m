Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1KWW0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:26:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1KWW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:26:01 -0500
Date: Wed, 23 Nov 2011 16:25:55 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.2-rc3
Message-ID: <20111123222555.GA1094@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus - Here are 3 eCryptfs fixes. The first patch solves a race condition
around the initialization of eCryptfs inode info. The second patch solves a
regression in mmap support. The last patch fixes a kernel memory disclosure
which was fixed using your suggested implementation.

The following changes since commit 6fe4c6d466e95d31164f14b1ac4aefb51f0f4f82:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2011-11-20 14:59:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git for-linus

Tyler Hicks (3):
      eCryptfs: Prevent file create race condition
      eCryptfs: Flush file in vma close
      eCryptfs: Extend array bounds for all filename chars

 fs/ecryptfs/crypto.c          |   26 +++++++++++---------
 fs/ecryptfs/ecryptfs_kernel.h |    5 ++-
 fs/ecryptfs/file.c            |   23 +++++++++++++++++-
 fs/ecryptfs/inode.c           |   52 ++++++++++++++++++++++++----------------
 4 files changed, 70 insertions(+), 36 deletions(-)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOzXLzAAoJENaSAD2qAscKPnsQAL7rG+ENiQZorXpGT1EGV9GG
74hIoN1pNpSrOB7lNBK+rVNL3FS+oKrjgS1mgB7cP7D/5jfOOsaunGtJhlwcZvA8
V3dh1P9FlSNRkKX24255KvAfTyjllQhW0MBIm7DO9xf/wPqjpRuutV1wbcaZI/2i
6+PHIhERC3MspBL8HoNyKNfCovZyZ/QXx33A/QDDyaHXVgFHjW2SFn+jEiELhNpG
BO+6eo/D1zaF7oAS5GmpJJrhWn2v3H/ncH1LPoVLU6z6FQYLYTF4PCcr0//m+ua0
l78ZtQavxSTXjfaiVkUL6/eW0mqAoU5F5RsMRj2LN3SFW81i0p8mBtMpZm6sgfeU
uro6LTf7KDwNQBdKM3E1IowTmpQ6faczI0iYXMGeyFidSRvzWFYw1/ortvB7YPWO
LonMj/bnzIjKmvMNSd25D3F+VeDWAmDKj+e47l3E0SJBOADt7DA5os1LcEn7xm1G
sLhbs6wjoDubHTr7giBpgQ2Z3kUo5or1A1Gp99MuZVY7UNXzubk8tsmXCDVFZ7i3
VJyvJ9ImsIPlHVeHXIzOK0+aa3HAkPwCK95asjEanrkbrJoRaxz/Hv3kiXjIpzAh
zzduWi5aY6qxFHqoj3t0YyFsGk6O2LkniWWVE/9j2DD6+IvJ67VBkfvCMdZUmKVK
/gLS3eBVV5IDlUUGFYwf
=i21a
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
