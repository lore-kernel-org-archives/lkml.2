Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1LVXCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:02:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab1LVXCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:02:43 -0500
Date: Fri, 23 Dec 2011 10:02:29 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST]  md bug fixes for 3.2
Message-ID: <20111223100229.1911a54b@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SXWfCFzMOr04h7CbfWVc55U"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SXWfCFzMOr04h7CbfWVc55U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull these 4 patches for md into 3.2
There are fairly simply bug fixes.

Thanks,
NeilBrown


The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

  last commit being 961902c0f8240175729274cd14198872f42072b7

NeilBrown (4):
      md/linear: fix hot-add of devices to linear arrays.
      md/raid5: ensure correct assessment of drives during degraded reshape.
      md: don't give up looking for spares on first failure-to-add
      md/bitmap: It is OK to clear bits during recovery.

 drivers/md/bitmap.c |    5 +----
 drivers/md/linear.c |    1 +
 drivers/md/md.c     |    3 +--
 drivers/md/raid5.c  |   14 ++++++++++----
 4 files changed, 13 insertions(+), 10 deletions(-)

--Sig_/SXWfCFzMOr04h7CbfWVc55U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvO3BTnsnt1WYoG5AQIFJBAArV82YKlkeqbc374oWASzk1pSHbfxQq2c
9Al34kMHxUDXo4+9kIdryL1tBCEdcKn+xAPVNhJWlheEG5zfnSXFTXbJo9qOz7vd
Lfvo8MNscuLQYxv3+LMzk/qvKMdpKqDXeLuL4owYBHXuHYJL3JdgkXOlFrXNGsUE
skZHeXC++b9wXhRN0KsqmUHAZfoqhFtPhPkptMAze1FtVWZJDpNiIDod+PYQ/n3e
TPAK77xbUMQZQTfmYCb9IcGmOOkeObbNJ8wiOwlQyrqrWsvXfJ8piLUBdoc3NveC
sBSrb/B9mzSbtBWO1GvAxN+dDLpjIlqCt49Tf33yeNAR5mwMyO1MtFBiNUMX954b
3Wq4dCkqTg4TGRlOvsvW+dmSPr9TSVR9vzlYWTvbm09rrmGLqsS/trjuaBX2IXYU
duPqofHCvKYmmRXEA9un0OlcKRKso6JWXNjxu0FSkhG1TUdZBs/SBxtvf3pa1G+V
P7s2VViV7u5P1UjniNDR53JMj8gL4rAdkrLb3fL8DDTTpZvLFrDtEk+L2jMuy+F7
rw2EO9yLAW7nQiBzq2Bw4zduedCp10cal6mWqL/+z3mok86LseK33IsIX+K8hNpV
hL/b1TfW/W9i163nHKsjE10pbnbdptQDLbL+X+acU3DRTBmIdwBsTYGytmEOL8w6
E50RD3MQb7M=
=VN/X
-----END PGP SIGNATURE-----

--Sig_/SXWfCFzMOr04h7CbfWVc55U--
