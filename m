Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2KZMeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:34:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50850 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab2KZMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:34:22 -0500
Date: Mon, 26 Nov 2012 23:34:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121126233413.0da411302d1402d4423e6f7c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_23_34_13_+1100_fLrKu2tcBN+B27t6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_23_34_13_+1100_fLrKu2tcBN+B27t6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/page_alloc.c between commit 5576646f3c1a ("revert "mm: fix-up zone
present pages"") from Linus' tree and commit "mm: fix a regression with
HIGHMEM" from the akpm tree.

I fixed it up (by dropping the akpm tree patch) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_23_34_13_+1100_fLrKu2tcBN+B27t6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2HFAAoJEECxmPOUX5FEyhYP/A7RSTnDVFFhl8/gjt1+xJA6
OFuEMwWa0bJi0GX4uoi3F/Of7uz4vUfiM84aOl/LDh6jGP4kk/Vq71ZOrWJzRz/Z
ILawIm/t+7Lrn/dVTsIOGDXL7KizV2L0HNkqyFMcma/CS32RF6Fab8RJ/MZFr9gF
s48nuCWjV6nDOIJ7a2/NfLcb1g6eMFRjfoP0zu2i/ylbblFGCjwWgqPbuhUPsxY4
KNAdHrYJsdkAXvPBG2bwLtdq7RDb6zA3CiqbEQPl3a96VcxzTQo/xyCy7MyXWPfW
R5shIec74W4K7OFfpFxspPpCqAXBeJygRvuxS3+MKU0S+2ERhWHOudfx5AFk8QPV
vm/WpltK2BYb5fOqw5u4lxK+w0QqBJLMtb9BEcnBtaPSzgsAcaxENzqrXjWMc2Je
cBMJIlXXxP/hqxjHmY1Xw4HP+XdiKLwu1a16Bd4jyGe1YJw55J7e1gtViilp3WG0
twVkkQFp5VH81Sn/+1f18UOfhtNh0mXKedrT2BE8HuIWEXf/4oqYjJyZ9tZZVdyG
v5n4WTxdRVZRmcct57cwTqWzdiqOda9TE+k3ThdY1nlG0fh8xVrDwlvuI51yjZ36
2nY5k8ZKgqOkpfAv3oL5mUgUNI+uQAW7u7nQbezEkg1sIFs7XejQbPBbDHAwusbi
A0UM6tjALfq8WMV9Z2ks
=e7XS
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_23_34_13_+1100_fLrKu2tcBN+B27t6--
