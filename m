Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2I0ChZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:37:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2I0ChX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:37:23 -0400
Date: Thu, 27 Sep 2012 12:37:15 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] 2 bugfixes for md in 3.6
Message-ID: <20120927123715.2e17d5de@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZJgT7RkGN+mSyonh3aY2aNC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZJgT7RkGN+mSyonh3aY2aNC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 6dafab6b1383e912cd252fa809570b484eb6e0dc:

  md: make sure metadata is updated when spares are activated or removed. (=
2012-09-19 12:54:22 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.6-fixes

for you to fetch changes up to 80b4812407c6b1f66a4f2430e69747a13f010839:

  md/raid10: fix "enough" function for detecting if array is failed. (2012-=
09-27 12:35:21 +1000)

----------------------------------------------------------------
2 bugfixes for md in 3.6

One (missing spinlock init) was only introduced recently.
The other has been present as long as raid10 has been supported,
so is tagged for -stable.

----------------------------------------------------------------
NeilBrown (2):
      md/raid5: add missing spin_lock_init.
      md/raid10: fix "enough" function for detecting if array is failed.

 drivers/md/raid10.c | 8 +++++---
 drivers/md/raid5.c  | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

Thanks,
NeilBrown

--Sig_/ZJgT7RkGN+mSyonh3aY2aNC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGO72znsnt1WYoG5AQJ7Og//UhHOOdAMHmbEdxa3bzW71a/+PgGabMes
HuM+IobyGSjq0/TEQarfinVOITKlSrkMBSVDfgqexyrMb6GUGoul6szHMti4t01Q
fJO3vv8e4dMiScarvECgoCpIEnqQv4NauBYTU6ut06zDireR3QmnBPklfHmEQlvH
RENOwpKlxEDEwK0eJMedO1ijTUbxVbywpmL9xbbpkdSAMNOZOdBIboFjD7/gnrA4
GTgMt3jMrCLUcl/HpHMgIckDvZoCodXPw6/Pme6GjHYEfx2fK07/fRH/OPSVC5fV
d0iE+SlOzsDk3jsgDxk1fOGz9BvxJnKk8U4Gebc9jDYjl5/zpi9v7uxNwxhYFED6
BKPTCuriali5BMr01DDj4sQ95Hr1rMwD0q/vG1rD/rb0Y4Dm7RXbQNblVVmr+1OQ
ntaZ6yKSNqefdJ15gojE/2ExVYwTNjrMSHTxv62CwjR/IEVjTwC5/KBXI2CpPxMB
sOBBHglhWXpih1Z5uWrfVj7Ko8fY9OIxoSUuOfs5tocd5gGzwrgQx6yQdrrW60cs
38KCL1Ov8t6xUlWArdmvHDRvyAAEjMlgDR4mRqo0k4Cqe68V/+ZzxLn4Fz3YVVsn
fTq2vlVAPheLSXXZ0fWulvPg879ykJ1a7eqTV6L4gp1ehd8XbF/ZCjiJgYaZ+eg6
TUvBaTfoPBw=
=FwRS
-----END PGP SIGNATURE-----

--Sig_/ZJgT7RkGN+mSyonh3aY2aNC--
