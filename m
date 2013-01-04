Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3ADD2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 22:28:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58130 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3ADD2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 22:28:15 -0500
Date: Fri, 4 Jan 2013 14:27:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130104142758.3eb182b1e873a88e6bd32f15@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Jan_2013_14_27_58_+1100_j8P/ZSBst0DM+NLd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jan_2013_14_27_58_+1100_j8P/ZSBst0DM+NLd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
include/linux/mempolicy.h and mm/mempolicy.c between commit 42288fe366c4
("mm: mempolicy: Convert shared_policy mutex to spinlock") from Linus'
tree and commit "mm, mempolicy: introduce spinlock to read shared policy
tree" from the akpm tree.

These two commits seem to be fixing the same problem, so I dropped the
akpm tree commit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__4_Jan_2013_14_27_58_+1100_j8P/ZSBst0DM+NLd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5kw+AAoJEECxmPOUX5FEgjMP/2ASvBs0VbLA8zGZgH8BeOyU
+KuNsPklcTDrc5zF3CiTUZ2kQeF2L3u7RU0P66WadZdfhvxFPHEyqSqrSwgaoBhF
cbU7aqCrimc8AmiMFHIh4a81QLf853muYRhBQFCtXnVMhy24RypBL0RUYw8Owgln
epRO6tYoGEI1ghu8zqwJx/oPNb+gLQ40V1het4/Q/wwxBpCOzdfp7HWk0hKvclZi
VtqeGWNn9/s6EUu9PzvKD5yQWmS2VoHo/iYyKs1ihHA7A0bQqU8KG7bRFUsp3K1B
tIDXIEXEVTSnjdpu8tXVBXO9oOU0JPHHcsen1xSXC8ThEzEq22vQMEDXzNPtO8xr
wRew1q4BTns0ja6PQbx1llsKqsdUQfxY2yp06QtbXHLeQXl/z5IL6Zwj+K2aVWym
GZYvKEn74Kc5espW9kw6ULL97ejdidmqfiGuEL2zTZOyp7y1MsanLi5GJsobLtvw
k9NqxBwsii3NERj/9kPy4MJZ1iPb4KtNVkF33j5GDF1zH72sg/y/aBkYxN3xBxc2
/jqDQj0N2dVWfB0k5SuhYw+PcPZHrOHY4zM5D+Cw+6xI/zE+j0zfzPZXazX3lRPo
pvKVvkfTgAcSiOVIs3sZ7bVfmouJnJeqrZP/QmwFelvHctU+fCH8K8I1rwBuwUsA
7TBdMFIO6Qq1eLYWR/vV
=zg7b
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2013_14_27_58_+1100_j8P/ZSBst0DM+NLd--
