Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2EQEy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 00:54:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2EQEy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 00:54:56 -0400
Date: Thu, 17 May 2012 14:54:42 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Brassow <jbrassow@redhat.com>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] two late patches for md in 3.4
Message-ID: <20120517145442.5eeb0d1c@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6umdsNtfJ9OOI/Buc2oe3B1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6umdsNtfJ9OOI/Buc2oe3B1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 I hope it isn't too late for two more md patches.  Both deserve a slot in
3.4 I feel :-)

Thanks,
NeilBrown


The following changes since commit b16b1b6cd052acbacc0a15f934bca9b354534d48:

  md/bitmap: fix calculation of 'chunks' - missing shift. (2012-05-04 17:03=
:18 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.4-fixes

for you to fetch changes up to 0d9f4f135eb6dea06bdcb7065b1e4ff78274a5e9:

  MD: Add del_timer_sync to mddev_suspend (fix nasty panic) (2012-05-17 10:=
38:24 +1000)

----------------------------------------------------------------
md: 2 fixes for 3.4

one fixes a bug in the new raid10 resize code so is relevant
to 3.4 only
Other fixes a bug in the use of md by dm-raid, so is relevant
to any kernel with dm-raid support

----------------------------------------------------------------
Jonathan Brassow (1):
      MD: Add del_timer_sync to mddev_suspend (fix nasty panic)

NeilBrown (1):
      md/raid10: set dev_sectors properly when resizing devices in array.

 drivers/md/md.c     |    2 ++
 drivers/md/raid10.c |   56 +++++++++++++++++++++++++++++------------------=
----
 2 files changed, 34=20

--Sig_/6umdsNtfJ9OOI/Buc2oe3B1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7SEkjnsnt1WYoG5AQIZRA/+O232+zpdY01Xc/c8n11NDby//epKaK/D
CtBpZF4lLyuVswmSwQ0fNB00a+0elEhF3Ukm0b+QOY8QksE2OZ7/U1ejQmyCMQFk
o/9oT50KmcFAnFpEXmepUvSs/KM18HQx45ubFiZ3+pYAsRJmh9xRN4Z2Px3l1Ny3
GwhYSsvVkV+dV5IPqGqY6Q3/Jnsi2WmmFyFZySVO9NiWae0VERIc4vFEO0cBxwlM
Np78SVJ2q/oV/YgA3YV/SLG9DUtLXSSffLt4bpHrq+YAVpC9Y1mAuvrdPzK4wIB3
NjX0vDoUUJ9wX8ZzsCR6Tw+h+jGxOAOAHaLZtt8Y4W/YUEvIWEl0hGLQBAOtqh/n
oHdy+akErAuT6iCX1z7T9ONo5y4ovIyjEfnxO7n+P6faDx+XKAT2NZFV+mwq+oSQ
Q5FK5W52ibPdgIltnCfAiROqDeuuG/KJaoc3C/gBVWQnVtoWPn+duAee+Vknll+G
4HNwHVt4SVRWvIhGLvIjgJPIkwA4zeNbmIkAV0Nb8jcotpkoYQ6zn7jYuVGDopP0
Rsi6OuZvuh3l30xCGnqzT5dOD+Kux8uWoYiMazGibI53ODX5kwK/hboKGThnJ1fB
Bca536Qk2mADPAE25xbeuPqOElsLRuQS8O3H7OsinHc2PEWJyolBFvxQnELSVTg7
mS586hjdn/4=
=Glrt
-----END PGP SIGNATURE-----

--Sig_/6umdsNtfJ9OOI/Buc2oe3B1--
