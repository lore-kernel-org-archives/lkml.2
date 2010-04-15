Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0DOCma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:42:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab0DOCm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:42:28 -0400
Date: Thu, 15 Apr 2010 12:42:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Divyesh Shah <dpshah@google.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100415124222.8e0e7132.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Apr_2010_12_42_22_+1000_15=DJSsZ0Rvv5DeR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Apr_2010_12_42_22_+1000_15=DJSsZ0Rvv5DeR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "get_gendisk" [block/blk-cgroup.ko] undefined!
ERROR: "sched_clock" [block/blk-cgroup.ko] undefined!

Probably caused by commits 34d0f179d6dd711d3fc13c0820a456c59aae8048
("io-controller: Add a new interface "weight_device" for IO-Controller"),
9195291e5f05e01d67f9a09c756b8aca8f009089 ("blkio: Increment the blkio
cgroup stats for real now") and 812df48d127365ffd0869aa139738f572a86759c
("blkio: Add more debug-only per-cgroup stats").

I have used the version of the block tree from next-20100414 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Apr_2010_12_42_22_+1000_15=DJSsZ0Rvv5DeR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvGfQ4ACgkQjjKRsyhoI8wgbgCfaXMdyMN12sOnnqQMsdqUhikL
IokAnRYmz+TRmP4hx5dX4wBa9pe8aHlu
=XGmK
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Apr_2010_12_42_22_+1000_15=DJSsZ0Rvv5DeR--
