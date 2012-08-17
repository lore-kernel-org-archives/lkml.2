Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2HQEzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 00:55:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42640 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2HQEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 00:55:45 -0400
Date: Fri, 17 Aug 2012 14:55:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.khan@hp.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with the slab tree
Message-Id: <20120817145535.57f37be87deabdcf9b3788e7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Aug_2012_14_55_35_+1000_3IHLVAeYiZdmKUnJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Aug_2012_14_55_35_+1000_3IHLVAeYiZdmKUnJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/slab_common.c between commit 77be4b1366c9 ("mm/slab: restructure
kmem_cache_create() debug checks") from the slab tree and commit
"mm/slab_common.c: cleanup" from the akpm tree.

Given that this akpm tree patch was applied to and then reverted from the
slab tree, I have just dropped it from the akpm tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Aug_2012_14_55_35_+1000_3IHLVAeYiZdmKUnJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLc7HAAoJEECxmPOUX5FEZdsP/RsHorI67/ebXw7bNTChwCaJ
tEeF2TttwFo+QvJFYfGJ8IVdJXU+RZd22tbOy9oMuSfUZ8O8l4LbUyyJJFbzCKe7
OaP4dFahJ6h0Gd01KtxOFgEESc7bkd3bnajreKUQqC96/z3mIzFxyf8LnwG4edmP
cGzXLaYigRzmMWYcCdThSsV3E1PIwz2nLESRb7TVDL/JlM4Zx2uWIX37vEXByDxV
SFlWUX1z84V/xeYwN2TKy5lHftBwWk0wz3LJP69VIl2U1fsNJq2/gG90Bkmqs/by
BZT9CeM9b+UHMiFCZjcQ8ynxQtmVeB0vJXOouwK1Pg/S8iFDwXIcF2GNbh/AmkQq
Bew68GbFbr+FuySOHm+8wnuMNuRQCOarLpg4bhQhaTkyul74/0j0ICpV56KUzqk9
37tEFjIrsSgddN7UevaZTsZipEhBg5AGUcEbS9vz6ODo1B+09+xy1b3GRjOGA8wN
sQp5oIz0oQJLjz3WRwqh/fcAE3nypsQ+BnzA+msglTYrdc/9cwyipIl/gcNS/RUE
5j7hu3i9MwD8kFxiFwHEdfDdmbZzewx6tlbrkMqLRwKTu9Ee4hFO8w9LegVR+bhQ
xDitXAlrlt87tTbR4WoAeepZz9cf1p1rTclTVyJAaCVmqPQSgIr9AkIpKoHdysiR
akSKZIoQsS0J9no5XAk3
=vnfq
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Aug_2012_14_55_35_+1000_3IHLVAeYiZdmKUnJ--
