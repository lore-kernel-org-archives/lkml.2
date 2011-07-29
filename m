Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1G2Dtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 23:49:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55970 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1G2Dtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 23:49:39 -0400
Date: Fri, 29 Jul 2011 13:49:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>
Subject: linux-next: manual merge of the l2-mtd tree with the mips tree
Message-Id: <20110729134929.8fb95f90043370cb3eb9c892@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jul_2011_13_49_29_+1000_Nf.gTQ+q2UU=HBi7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jul_2011_13_49_29_+1000_Nf.gTQ+q2UU=HBi7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/maps/lantiq-flash.c between commit c84c24dc7ed7 ("MIPS:
Lantiq: Fix MTD registration of NOR device") from the mips tree and
commit 31963c9999a3 ("mtd: lantiq-flash.c: use
mtd_device_parse_register") from the l2-mtd tree.

I fixed it up (by using the latter change which supercedes the former).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jul_2011_13_49_29_+1000_Nf.gTQ+q2UU=HBi7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMi3JAAoJEDMEi1NhKgbsej4IAI05D6+FnEcoJs1tqTRhOMqy
j3jzzNnJHcGETlWHg9wGb2OnZtTgTfqFuDN+G8YODJIxRSFmBBvKHuQUl/Ua6S1T
XziTabSEBHqkK7IaeAbR57d6smrVA+TQ4jQcpiYBBH5g1+JWrdwvf3/RZ9ujSKTE
2T+4GTUweY6m06NoWXdeBEsKSR8qb0dqaYswsSrZFm172iUlwD97dT7oEFCBb5aP
td8G0pFetnpCmyF7VMmfhWlaW4DIzZiHooKPpxlsv7J4bEwptNgJ9SlyWuA4lOsS
jwk8f1FVFbMTkby6s1qkGL/QEm4VGYRL1lO5ZkL2Jw+DNyGTS5ps0dkhNCA+yss=
=CM5V
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jul_2011_13_49_29_+1000_Nf.gTQ+q2UU=HBi7--
