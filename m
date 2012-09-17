Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2IQICZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:02:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IQICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:02:18 -0400
Date: Mon, 17 Sep 2012 18:02:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh <joshua.taylor0@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the input tree
Message-Id: <20120917180211.de28c6e4ad5ed73ae43c162e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_18_02_11_+1000_0q6Zg3+BNYjhVL6k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_18_02_11_+1000_0q6Zg3+BNYjhVL6k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/input/keyboard/omap-keypad.c between commit 9e14f36bb577 ("Input:
omap-keypad - fixed formatting") from the input tree and commit
f799a3d8fe17 ("Input: omap-keypad: Remove dependencies to mach includes")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).  Please resist white space only patches :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/omap-keypad.c
index b03c5b9,2bda5f0b..0000000
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@@ -421,10 -346,9 +346,9 @@@ err4
  err3:
  	device_remove_file(&pdev->dev, &dev_attr_enable);
  err2:
 -	for (i =3D row_idx - 1; i >=3D0; i--)
 +	for (i =3D row_idx - 1; i >=3D 0; i--)
  		gpio_free(row_gpios[i]);
- err1:
 -	for (i =3D col_idx - 1; i >=3D0; i--)
 +	for (i =3D col_idx - 1; i >=3D 0; i--)
  		gpio_free(col_gpios[i]);
 =20
  	kfree(omap_kp);

--Signature=_Mon__17_Sep_2012_18_02_11_+1000_0q6Zg3+BNYjhVL6k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtkDAAoJEECxmPOUX5FE0s0P/ic7bEogQ8nWeUD2mQu1AhHj
3i/oBYJuYGsRrjgd8TPs4b/dWsueDqWgvDAj36fPG4vzPyzJq593sT4JVNd+808e
dtdvsre/3fAHcSxcUHYimWgY16b3gehGAA8dA2IlTb8Y6o7D8deuP+4rgD5q1Hd/
NONhxdjJj4jVSiDhH/MGQMeEV0h8xMYugBpSvFvkOh8zAGrIlLzrsWlc4o/Czkf6
UGK7XoPV6cVdFLSUPvGb8enZ/LckDAUlxjMBU1gVUdsyci6qoz8f+lM0ddefglXA
Kcgd0D8zRpV77y7JrfvQqRvDafCkMuyoncRXSURQkbnF7378KnpEHGEAZEkW5fjM
dhi39y6C1RbL488tWpL5B46qRZVv2swdIx31f9K/Avrf+II9+bPyF2EF58siNWnQ
JNQrwLEGzDdvzxZPLFgr4BCvCaQ6u/X+svdmos8UkPzvoNjyQzd+j4BM6CXcO9Gv
BZ3mbkE1xt8KbFEiyvg3bBHReveqaaqIpduuptzn2EA+m1mMfEtfMC7sriRkFqin
UKmgwWlAXW7wkpaQj5OVFfOwzWvazlwLQt8+qeWyCX+2JgcfusdbLGVbOr6r67n5
L3rsQvj0kH6nsKiB3pmpR2vBl/nhEstqpcOF0dAoR4SzhRNP4fsdWWffC9LWlYcj
+T15k7Z6K+71oa+S5X+A
=Vz/8
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_18_02_11_+1000_0q6Zg3+BNYjhVL6k--
