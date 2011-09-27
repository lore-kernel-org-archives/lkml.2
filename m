Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1I0HOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:14:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35147 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1I0HOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:14:08 -0400
Date: Tue, 27 Sep 2011 17:13:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20110927171359.db102aea408b07771336d6f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_17_13_59_+1000_wZ7KECTcqp1OmHOA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_17_13_59_+1000_wZ7KECTcqp1OmHOA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
drivers/iommu/dmar.c and include/linux/dmar.h between commit 318fe7df9d84
("iommu: Move IOMMU specific code to intel-iommu.c") from the tip tree
and commit 432fb2751763 ("When do pci remove/rescan on system that have
more iommus, got") from the akpm tree.

The former moved that code the the latter cares about to another files.
I have dropped this patch from the akpm tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_17_13_59_+1000_wZ7KECTcqp1OmHOA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgXe3AAoJEDMEi1NhKgbs1pAH/18IYP1XUadNiq0X1xlwL55X
hXOw6yOorsPM9I/CF67NGIB1flqbKPh+P34b0uTvdi0E2qbMvIATw8HhFcNaJ1RC
+HYeEVJmgt+anixrSPBJgNorMlGbkHhyKn2ordSTEOZFfc7ZrJKMzrPPYCeeI4CC
eI51NryYX6+UXPY2bf3kVQNWYSvHxyXB0Cqpow85dO1PcbLiXV5qvObSl1t4SfW6
ixECmcmZ6syeRMVtMGChOi2njCFtsMc/GlGM9Eaw6zf41/r7Dp5aEQ+jm+n9wcas
BWb+E5EkGq1mzcHoBqtPlnBoOiacLfem0YdcQ69L0dbcwvErQmXhMuY7/dsPLx0=
=E289
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_17_13_59_+1000_wZ7KECTcqp1OmHOA--
