Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2DXA6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:58:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2DXA6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:58:01 -0400
Date: Tue, 24 Apr 2012 10:57:42 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] md: a couple of minor bug fixes, and one serious bug
 fixed.
Message-ID: <20120424105742.57cefab7@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MEs0.IG=s5g09WjSg7TfG/N"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MEs0.IG=s5g09WjSg7TfG/N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull the following for the next -rc.

Thanks,
NeilBrown


The following changes since commit afbaa90b80b1ec66e5137cc3824746bfdf559b18:

  md/bitmap: prevent bitmap_daemon_work running while initialising bitmap (=
2012-04-12 16:05:06 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/md-3.4-fixes

for you to fetch changes up to 30b8aa9172dfeaac6d77897c67ee9f9fc574cdbb:

  md: fix possible corruption of array metadata on shutdown. (2012-04-24 10=
:23:16 +1000)

----------------------------------------------------------------
md: a few more bug fixes for 3.4

2 are tagged for -stable, one being for a fairly serious bug
that can corrupt metadata and make it hard to recovery an array.
The other is for a more recent regression since 3.3

----------------------------------------------------------------
Jonathan Brassow (1):
      DM RAID: Use safe version of rdev_for_each

NeilBrown (2):
      md: don't call ->add_disk unless there is good reason.
      md: fix possible corruption of array metadata on shutdown.

 drivers/md/dm-raid.c |    4 ++--
 drivers/md/md.c      |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--Sig_/MEs0.IG=s5g09WjSg7TfG/N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5X6hjnsnt1WYoG5AQJwABAAtfI8P5VJNJrrlHKEHa7J8xv1KB3KPGJr
016rtH0AeJOLdY95ojCENHCV+cW9IicfeMzuhnbc+6ilFfFLSsRSy/s0g/DodD/O
Quvv/lECEzIw4uS49EU07XSZ2x6XCjzO5Quo+tv64EZEVP/DjBJpRKqDEcO03yNr
duGQTZPWdNYNzTRircuQP9GKEZMDHYoN6VSdXenb3l46E5jQi2fpTVulANwnT1U8
MRZOHp48n8qabEiyltGL8OhHSEzSk9L4j5dpfW2XKMQmqddGfLWQq2PmW3nL56rG
NoG9OBJysp1kqzoUCd/wgE+VgtBVrDlbnLjwcnZA1UikA9pdLHUNhMwEkXgtrwyt
Vo6sEB+0brvon0FTFh6G4T0VU3zFWD2oewd1srUKAE4tm5B536tt5WoC72mJiEs/
28SEzWRqcguJ9ggpp3Q4WvlgMKaijKLyqLS9ikO0FQ1/gZKLmhysTPcpmiKxPmgi
6BFclECjY54skePqdYxC9GUR6DUnpVigZZaDk87rAq/QvyzB1QFDqV8Nl3RskQy9
C0OCHw0zuDHn7W6xksBZZj2Ee70ArAeFPrtebk8LySoEjWSqcp4Q19+Fxtfxrh4m
2aF1XkX6dEHATOaglIlJ6ZrDOOYJpRCMjC+JYvI8nvybmsjLHBzKRaXv05bDLrsx
vIvQSkKM6lQ=
=ZJvx
-----END PGP SIGNATURE-----

--Sig_/MEs0.IG=s5g09WjSg7TfG/N--
