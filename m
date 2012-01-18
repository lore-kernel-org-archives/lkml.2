Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2ARXgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:36:35 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54316 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2ARXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:36:34 -0500
Date: Thu, 19 Jan 2012 10:36:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20120119103626.a9b21533cf30da57ddc54947@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jan_2012_10_36_26_+1100_oXopTEUySA/IMY2t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jan_2012_10_36_26_+1100_oXopTEUySA/IMY2t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/block/nvme.c: In function 'nvme_alloc_ns':
drivers/block/nvme.c:1336:2: warning: passing argument 2 of 'blk_queue_make=
_request' from incompatible pointer type [enabled by default]
include/linux/blkdev.h:830:13: note: expected 'void (*)(struct request_queu=
e *, struct bio *)' but argument is of type 'int (*)(struct request_queue *=
, struct bio *)'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Jan_2012_10_36_26_+1100_oXopTEUySA/IMY2t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPF1d6AAoJEECxmPOUX5FEfG8P/RoDpjVhxarIZwF017Q/9Y/t
DgfM2O8wBv3y/LBMXM9I7H/WNVwDbIeJKDr/em8Ur/IVi+kLsHn3ljJ69bss7GOs
nu3BLZs3s4RXJmRFMGcOp8dmiZIsjqoCdlsf19AKHLQJk/ncGomv0WWGkjHFEcRC
9aE5iGpXMuv3/TanSuDAiYgxTJrVzgYvvWMVOw7UlvwmuyfDCdkUDaANWDhpaxVt
u88yAClG8fGXu209/IkIpuriDaKqAmMkfhzEpqe+o2+gIe49tjB9zw+gdA4Vhohd
gzGtHJH6ReWGGBxzRyHauEKIwvihUW1MKg+anplSZppUdAE3CkdZYN+SO2hsihJS
MQxceVC3s1Ql1te+iatQyNYNTh5W4PYhySA/88nHo2tl+sBSlFQxhQku9+O6JfFw
W6OA0voF0iynRLCfhonQg1TVr+4qH+XgyXoY8ZM0f+8eBa6xXNfSNycV3ApDpZd6
QYThnUjmU3b34TDGaTreVVvtYuSzHOwhZWXarI06bv6bN+2LLAYclYfMzd1iTQPB
Az4d1ot8c/neiRuJowrdZhMkx5rJjj/+EYRRrxIH1oiXbTJrb1DuOsGBSwXsT+UE
TvCI/F0xPNbkDe0O2Uzt8jKCDNOt2R023aR3b0mMZhIF3SoS8HyQ2sEJENHfWufr
WvkQ86vlc3Djv7dwivUJ
=scNM
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jan_2012_10_36_26_+1100_oXopTEUySA/IMY2t--
