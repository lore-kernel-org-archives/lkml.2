Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2BMFkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:40:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47611 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2BMFkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:40:12 -0500
Date: Mon, 13 Feb 2012 16:40:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the dma-mapping tree
Message-Id: <20120213164000.da84dfec7723af3a9eb3e13f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_40_00_+1100_7TBPtlBtNN+/R+Dj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_40_00_+1100_7TBPtlBtNN+/R+Dj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the dma-mapping tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/vio.c: In function 'vio_dma_iommu_alloc_coherent':
arch/powerpc/kernel/vio.c:500:21: error: 'struct dma_map_ops' has no member=
 named 'alloc_coherent'
arch/powerpc/kernel/vio.c: In function 'vio_dma_iommu_free_coherent':
arch/powerpc/kernel/vio.c:514:15: error: 'struct dma_map_ops' has no member=
 named 'free_coherent'
arch/powerpc/kernel/vio.c: At top level:
arch/powerpc/kernel/vio.c:615:2: error: unknown field 'alloc_coherent' spec=
ified in initializer
arch/powerpc/kernel/vio.c:615:2: error: initialization from incompatible po=
inter type [-Werror]
arch/powerpc/kernel/vio.c:615:2: error: (near initialization for 'vio_dma_m=
apping_ops.alloc') [-Werror]
arch/powerpc/kernel/vio.c:616:2: error: unknown field 'free_coherent' speci=
fied in initializer
arch/powerpc/kernel/vio.c:616:2: error: initialization from incompatible po=
inter type [-Werror]
arch/powerpc/kernel/vio.c:616:2: error: (near initialization for 'vio_dma_m=
apping_ops.free') [-Werror]

I have dropped the dma-mapping tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_Feb_2012_16_40_00_+1100_7TBPtlBtNN+/R+Dj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOKIwAAoJEECxmPOUX5FEYiwP/i9IykpU3Dw2cYZkWh+yZlwT
uzwHr+uWNjCaBeDyDYT0m1vh1ksmkmTlnjProU5XZte1lZ5zeEL/0uyWeExnFcBp
YWoc1AJ3ie32b9IoiPERNqbUpYbOTJ4UjvMq5BS3cmyRd+LA9aNwkzGsLyCWr/wS
pjlF9MOP3Di2gnVpovz7HPzXl16sn4ftrAh+gtos+iUJ2fwskq9JGEbU8hltUkLD
8nd0wUSagWRMd10ZwBY+7XaJcWFemayWCZR33/zAeuLuLXjjAw5AUuzWV0G+iFSD
zUQUTIN0OOn7OHdqyHxMWznIfK8STaBkoVsJ6OqpKo0Pq9F/p1Aj0CNUUcCAxpkZ
Bhm6KaM8sk+xxxmnAhVzHsOPvXjEYIJCjDsUWI1H0L100H2D1lIRVCL6sIsrxE9z
5CQw4lVH2bwwEJWEHo3aoKFenEUIWvnRkbwnDV/oT11jmqyx6f94kcjlc+mHWMwN
fgdA/6+lMTpmyP3AjRck6QR4XEOrdd9v4Onxm3iYMFRunZgrrMfJC6+6MwAdcDeL
eE6r7CxU3ID4fXDpBr69l4rCSgD5sy08I/IKgVCA1odM88c3nqPohs1cL1UXG2c9
JL3ss/e6xsemBInJbE5I8Vw6XxwsGoU4udAM8HwrG1NmTIMsofnkU2ixotNccO0J
ZkyNPEvSfDVUyzl8BRzl
=lGdy
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_40_00_+1100_7TBPtlBtNN+/R+Dj--
