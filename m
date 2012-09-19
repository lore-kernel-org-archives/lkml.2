Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2ISDCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:02:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2ISDCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:02:08 -0400
Date: Wed, 19 Sep 2012 13:01:55 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] 3 fixes for md in 3.6.
Message-ID: <20120919130155.1f783b29@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jf/JA9IjtsIZk_EpG9pInJf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jf/JA9IjtsIZk_EpG9pInJf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.6-fixes

for you to fetch changes up to 6dafab6b1383e912cd252fa809570b484eb6e0dc:

  md: make sure metadata is updated when spares are activated or removed. (=
2012-09-19 12:54:22 +1000)

----------------------------------------------------------------
3 fixes for md in 3.6.

One reverts a recent patch which turns out to not be such a good
idea.
Other two fix minor bugs with the new (since 3.3) 'replacement' code
and have been tagged for -stable.

----------------------------------------------------------------
NeilBrown (3):
      Revert "md/raid5: For odirect-write performance, do not set STRIPE_PR=
EREAD_ACTIVE."
      md/raid5: fix calculate of 'degraded' when a replacement becomes acti=
ve.
      md: make sure metadata is updated when spares are activated or remove=
d.

 drivers/md/md.c    | 6 +++++-
 drivers/md/raid5.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--Sig_/Jf/JA9IjtsIZk_EpG9pInJf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFk1oznsnt1WYoG5AQKgBxAAmz0bWhgOYKOSh2nYpbTDSUBCfYtRKRAT
hklr3yeCKP+yUSdQ4ctSumLH0BIlsFyihyxDDVHOfIBjqQnCKYOdu7UVf+mJBbwl
wUji6QkXxAB9m2q/NuHlb8nPHn9Oyrq5zp05IqfTwSZNdw2M4UJQuDWWmgTWuZzZ
m0Dy2Fcjn65Sr9cdGY14RMlFMXZwaa+CmxOFFlOAaiqGSWN2kkwuZv23nVOXb4Yp
FBDKCHmbFAwKDgGXGaBaNahgMd0Wva4LIgjUkLAdz/0u1NfIPxb2W5Si1CpJ59wY
lOVVFObe18sONV6LqrTFFzMBPVTt5ofmdZJ6qVt/EwP4vf6p2+N21aTGuryOzD8C
XX6eTLO2yan2fcEVkWMtK1j4pAdeMZm2KoekK6KOq0TPx2o9kWZwIoR+Zjavs8rI
l3ZAevhJybvWNh1Ew2Ha1PFMHKQAth9IdYmdjOXbfVaPkMqP4ZqfMavWJG6tCXuR
0N+WSPpDKLbdmgFsVTg3qymgs51/0jiZpVnWcK9gw7dNo26bOdW4VB1oyehgDZrW
IELETWhUaOBg3G/XjC2yUFxFjL3o9NugKoV/5NzuHzpRlu97o1Sznjxr00/3Kivy
JgwsyYG06tBP4o/GpZ+uZea4mnAHVFvsPjIAGaF5f0/AN93jZHQ4ywAeh5JJfmi5
1u8Wa7RvEtw=
=43WA
-----END PGP SIGNATURE-----

--Sig_/Jf/JA9IjtsIZk_EpG9pInJf--
