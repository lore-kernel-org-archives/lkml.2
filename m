Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab2JaBJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:09:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2JaBJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:09:18 -0400
Date: Wed, 31 Oct 2012 12:09:39 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jonathan Brassow <jbrassow@redhat.com>,
        David Howells <dhowells@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Subject: [PULL REQUEST] md fixes (plus UAPI reorg) for 3.7
Message-ID: <20121031120939.30e27e50@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k/=ydgv9JDNxOLoNUh/n=Cv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k/=ydgv9JDNxOLoNUh/n=Cv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md-3.7-fixes

for you to fetch changes up to ed30be077e705e0dff53bfc51d23feb8aeeab78f:

  MD RAID10: Fix oops when creating RAID10 arrays via dm-raid.c (2012-10-31=
 11:42:30 +1100)

----------------------------------------------------------------
Some fixes for md in 3.7
 - one recently introduced crash for dm-raid10 with discard
 - one bug in new functionality that has been around for a few releases.
 - minor bug in md's 'faulty' personality

 and UAPI disintegration for md.

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/raid

Eric Sandeen (1):
      md faulty: use disk_stack_limits()

Jonathan Brassow (1):
      MD RAID10: Fix oops when creating RAID10 arrays via dm-raid.c

NeilBrown (2):
      Merge tag 'disintegrate-raid-20121009' of git://git.infradead.org/use=
rs/dhowells/linux-headers into for-next
      md/raid1: Fix assembling of arrays containing Replacements.

 drivers/md/faulty.c                  |   5 +-
 drivers/md/raid1.c                   |   2 +-
 drivers/md/raid10.c                  |  15 ++--
 include/linux/raid/Kbuild            |   2 -
 include/linux/raid/md_u.h            | 141 +------------------------------
 include/uapi/linux/raid/Kbuild       |   2 +
 include/{ =3D> uapi}/linux/raid/md_p.h |   0
 include/uapi/linux/raid/md_u.h       | 155 +++++++++++++++++++++++++++++++=
++++
 8 files changed, 172 insertions(+), 150 deletions(-)
 rename include/{ =3D> uapi}/linux/raid/md_p.h (100%)
 create mode 100644 include/uapi/linux/raid/md_u.h

--Sig_/k/=ydgv9JDNxOLoNUh/n=Cv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJB6VDnsnt1WYoG5AQJdPhAAhRaWZECYa/O+15/LemiI+bSgt2DcZDVB
WRFfKvacrZbPpK4SYx/SkNeij69aHJ3dZg1d0ZC+TqDU+tPo58t/+f1yfKeOz1Mz
VXfjpu1AILDaLXKZ8miQTx3yb40bwgD+Jiz0rVTe2ldvZJwRx/tUMyWSMHGQNdKn
OdoZqZ7HRmkPQt3nOHFWLwDKV9do0D9Td/gyfRAl228kfbaaAHnbQrc1cbgyLjzx
yrBS/1cgM7yMdeH81mlPjjv4t8lB76s/chjsnKTP1HOo5T6m+k/F0R+n3riZ9Pz/
GlUJxkbMuz0kusNzUg+DzqZuKQmh/njOSCyTLTkSchKm/tdO7DTZab4fBxxlxCSF
nmPbp1D4EeXKmaEvW4HHihqFMo/eG6C55sfK4DhnfZNPk8gIxqq091UfswuiQv45
oOh2s9H3fqvQRTOr6e4E1oHj4Ynvxh46d7GyclShlPFzA1h5xgdw0eZuR9Om0AWe
WTtFvR8CHCr8fL1Hh/t3adW/3CAJCuJoAX5FL3YGEqBEagykSAPs6+VjOPu3jbhp
HtZsgNeyAcBh8VgYzxnW7AH3UaEw49Ebxc7dXciTZyQ+c8NIn+tuzzgVaApXcnRV
ZXN7n1Ex/GSRYgjKL/2JlwNGLZ6CBL+LvhvSj0WgV4NNUatiV1xe7+ZnK8ZGEogZ
nQCG9qMSJRI=
=9GdI
-----END PGP SIGNATURE-----

--Sig_/k/=ydgv9JDNxOLoNUh/n=Cv--
