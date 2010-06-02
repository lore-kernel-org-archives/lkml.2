Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab0FBEDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:03:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39447 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0FBED3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:03:29 -0400
Date: Wed, 2 Jun 2010 14:03:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the drbd tree with the block tree
Message-Id: <20100602140322.7e374a2e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Jun_2010_14_03_22_+1000_qmgOgDBi0rK_YRSd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jun_2010_14_03_22_+1000_qmgOgDBi0rK_YRSd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drbd tree got a conflict in
fs/fs-writeback.c between commit f17625b318d9b151e7bd41e31223e9d89b2aaa77
("Revert "writeback: ensure that WB_SYNC_NONE writeback with sb pinned is
sync"") from the block tree and commits
5c92877730b509fefc445bbba6b3bc441c2c272a ("writeback: fix early free of
work struct") and dff38fd3d1d0914ac0715445bbe21fbce9abed15 ("writeback:
fix non-integrity write-back") from the drbd tree.

I suspect this is caused because the drbd tree id based on a different
version of the block tree to what is in the block tree for-next branch.
I just used the version of this file from the block tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Jun_2010_14_03_22_+1000_qmgOgDBi0rK_YRSd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwF2AoACgkQjjKRsyhoI8y7WwCdHpBjAr/Jr/EGUhwowhgFPrz8
qEgAoLfPWJrydOrd+3Mvqdk6I9nVWc7i
=RKTC
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jun_2010_14_03_22_+1000_qmgOgDBi0rK_YRSd--
