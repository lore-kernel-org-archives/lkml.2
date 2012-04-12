Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2DLGKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:10:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2DLGKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:10:47 -0400
Date: Thu, 12 Apr 2012 16:10:36 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] a few little fixes for md in 3.4
Message-ID: <20120412161036.7730167d@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ibvVMNSJ5qChPJ_KRu/ux2n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ibvVMNSJ5qChPJ_KRu/ux2n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Thanks,
NeilBrown


The following changes since commit 5020ad7d143ccfcf8149974096220d59e5572120:

  md/raid1,raid10: don't compare excess byte during consistency check. (201=
2-04-03 15:39:23 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.4-fixes

for you to fetch changes up to afbaa90b80b1ec66e5137cc3824746bfdf559b18:

  md/bitmap: prevent bitmap_daemon_work running while initialising bitmap (=
2012-04-12 16:05:06 +1000)

----------------------------------------------------------------
A few more fixes for md in 3.4

Two are tagged for -stable. They can cause an oops, but very rarely.

----------------------------------------------------------------
Andrei Warkentin (1):
      MD: Bitmap version cleanup.

NeilBrown (1):
      md/bitmap: prevent bitmap_daemon_work running while initialising bitm=
ap

majianpeng (1):
      md/raid1,raid10: Fix calculation of 'vcnt' when processing error reco=
very.

 drivers/md/bitmap.c |    5 ++---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--Sig_/ibvVMNSJ5qChPJ_KRu/ux2n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4Zx3Dnsnt1WYoG5AQJr6Q/8CevWjtl3NKnY7tQ+3DAOHcNOdOxH/FMT
VnLyjqZHWWec65yfrlRo1Tca47o4P9YRdv2L1RQ4m2ON84Gz7Pf9EK0mIGIQEsPJ
pNd7zFJ4gXCM+6TQjrPfc34hjUjn49i1J/RmJkrxOakNJIsDEk0j2HMf6MGsGa6T
o+l9uzAeN5oLFkpPUurBA8xDr08y06UuAFTke9X8UYVjVdDOUqh7s8EXCUvx95mT
iJ6XJF7Bhofd0LRHWreBd8jibcsPYKIx/zZO2xgZGQzY1hPCACNfk73xSOsG4wFP
ERcvwUF4PtFpX5Gdhfy+M+W/71A4YA2F0QcfWixBFyzuCuezEawst62qwfO/33/G
o7fDCS57nMMT0VO9CWZF3eZ2AkiZCbXJR6Y1UQxR84jOzChIplyQgQJTruNIDVu9
NW6v4O++bS9GhFhnZsSvZDM68SGM8pmrk2bljeyQNePghhBOl0U1cM91AEOQ0YHH
cJilnWrlYEkTIarVhhDSN84aqJ6DFJhcyYmx7tElc5peHMuymK4OGtJYiixYHZju
n0o2GNdAlHKVy6sybCUB5D0fgkEWvqEkODsjvl+e1kmBVjXK3Lq+tLFkt3SOyU4I
PA7deczDkMIgPjQKZo4F3W+7IAneqQZFFMT891HkKethRAS9KXf01996R7QStNtZ
uK4DGEK/Fq0=
=Elfd
-----END PGP SIGNATURE-----

--Sig_/ibvVMNSJ5qChPJ_KRu/ux2n--
