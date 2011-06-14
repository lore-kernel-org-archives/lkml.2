Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1FNEZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:25:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab1FNEZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:25:51 -0400
Date: Tue, 14 Jun 2011 14:25:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>, Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20110614142542.c65a7540.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jun_2011_14_25_42_+1000_4D1q_xGO3vkVVtc5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jun_2011_14_25_42_+1000_4D1q_xGO3vkVVtc5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/mtd/maps/pxa2xx-flash.c between commit 51fb8326bc12 ("mtd:
pxa2xx-flash.c: use mtd_device_parse_register") from the l2-mtd tree and
commit 28f65c11f2ff ("treewide: Convert uses of struct resource to
resource_size(ptr)") from the trivial tree.

Just context changes.  I did the obvious fixup and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_Jun_2011_14_25_42_+1000_4D1q_xGO3vkVVtc5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9uLGAAoJEDMEi1NhKgbsNmAH/0uGcJzLVCh2kljd0nc5NZD7
cJgpdDLpd5z4CKY7HyDeKzKJiw12pZSwqhdVNhN9qxifWFxI65fkEX8ZGLSJmO/L
9CmKzZns5Jj8uBzkmpUTQlWIjUTiFUaEyQTwJlivm5YyYHFZSxKcfX/tv+Vm9jWm
qW5/hYswl/kzm2znD+0Mh1X3jbq3oRRet8GhZiPvlTQoxXrHP0jRzUpu1C+wUZHi
z15dGF1vylRlDFG00frWERhjjFrQrTwztRU1NucQgKSMdffgj1Hjz50hM47d9fot
+tO451QD3cu/MkJxnlALzf8mVSSbVpJISg1+yIkJ4Rvm+iGfvOcRd330qFinEiY=
=eJcn
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jun_2011_14_25_42_+1000_4D1q_xGO3vkVVtc5--
