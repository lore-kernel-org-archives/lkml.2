Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1JXUUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:20:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42964 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1JXUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:20:32 -0400
Date: Tue, 25 Oct 2011 07:20:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111025072013.1824cfd24495819777ad2660@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_07_20_13_+1100_u4tRn=3HkYJXF1j7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_07_20_13_+1100_u4tRn=3HkYJXF1j7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-mxc/include/mach/memory.h between commit c039bad00f21
("ARM: plat-mxc: remove mach/memory.h") from the arm tree and commits
ae4fa7f66e54 ("ARM i.MX: allow to compile together ARMv4 and ARMv5 based
SoCs") and 7409cd1cd554 ("ARM i.MX: allow to compile together all i.MX5
based SoCs") from the arm-soc tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_07_20_13_+1100_u4tRn=3HkYJXF1j7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpch9AAoJEECxmPOUX5FE8IgP/17dXm25zxmTwdc87PjwthGp
h7ZzIhBm7+t1A1FXE5/Hu4parAUH8ZBGMNuDDQMmxh4hTmhNjAi9oRwCX3zQ92nJ
HgT17Me9irlww2vQa1SpfeXCJrKpqskikbFvnZw8Qq1ZJ8qBd+pywaHOzDw8qePZ
oU26NVKrzNdv4C3RbeESr/I7MegcFsreSDlUfiYMSo3xhvKFtl6kkWtPGbv66mwM
U0UfA2FfNakj2FbsMeZ6G5CRxce1dP8R8adaV5OKFKBK37kkE91k7mKx1gfdFyTI
oj7MLic/iLP6fC4roMQzM4ZeIimlk5pUVwQFtxOQfzGZEwBexVZMOUohFOhibG6J
O9C3FDFSoFZP/Wi4oXyreD+J+DX3ups4/YgXhl/AdBYsxs6KhgtzJReubGZFGmco
eNuO7P19wGIloolsxn6I+xjQcnR1+NFZcdfUYmMloFa9d/r5h1a0AlBduakzlpC8
7OrYa+ZzG5QtxoyOkUm2cgTi7MCuRXtJnlOhOKsHvdH5t0V0mRp5e93us+rt8Ikx
diJcPWpZVFxAhDxqvDBbdtkHQsKtt4C/JSpcoPAP9hCbLBmCTTyASTgr7OQuXqXy
sS4tKGPcYSKUTnD5t48BPKO9b96wj1f9b5P408jb8y8rM4DGu4AbixHd/roTuXcj
86JJBpzkMAAeRnxtK71X
=TeSO
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_07_20_13_+1100_u4tRn=3HkYJXF1j7--
