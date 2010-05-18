Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0ERFUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:20:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab0ERFUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:20:38 -0400
Date: Tue, 18 May 2010 15:20:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the drbd tree with the block tree
Message-Id: <20100518152031.9a244971.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_15_20_31_+1000_NelEjYw54Z3ygQJ7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_15_20_31_+1000_NelEjYw54Z3ygQJ7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drbd tree got a conflict in
mm/page-writeback.c between commit
42bd225c0ba7c95af39293d39a950c48e7e5cb23 (""laptop-mode: Make flushes
per-device" fix") from the block tree and commit
e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback: fix WB_SYNC_NONE
writeback from umount") from the drbd tree (via its merge of the block
tree).

I used the next-20100517 version of the block tree today (because the
above conflict was not resolved correctly in the block tree and caused a
build failure), so I will also use the next-20100517 version of the drbd
tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_May_2010_15_20_31_+1000_NelEjYw54Z3ygQJ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyI58ACgkQjjKRsyhoI8wzaQCcC7BjrS41+6/VunWH2k22rV9I
5q8AnAzKvtDlvBqH2ypu67DzeLvaU2KU
=GaEt
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_15_20_31_+1000_NelEjYw54Z3ygQJ7--
