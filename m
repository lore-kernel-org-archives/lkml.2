Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2DXBVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:21:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44433 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2DXBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:20:58 -0400
Date: Tue, 24 Apr 2012 11:20:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning in Linus' tree
Message-Id: <20120424112049.45955d7025fdfb3ce182ed2e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Apr_2012_11_20_49_+1000_QK4cBF33qfYUt64k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Apr_2012_11_20_49_+1000_QK4cBF33qfYUt64k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Using Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
produced this warning:

fs/ext4/super.c: In function 'parse_options':
fs/ext4/super.c:1600:23: warning: unused variable 'sbi' [-Wunused-variable]

Introduced by commit 26092bf52478 ("ext4: use a table-driven handler for
mount options").  This build has CONFIG_QUOTA not set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Apr_2012_11_20_49_+1000_QK4cBF33qfYUt64k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlf/xAAoJEECxmPOUX5FEHlQQAJq9YR3/rjnso87zgRp/kovc
xCc4wflzGmavl23wNwIUZXGmNKn4OBJEM8xvxESGFr5VCw0zASkopWHwamI0rcCp
mRjXqWxjKrlnO1ceICNglQ/r3KT/WSkx6AbgchRVZcMBxX0pQNm/c2pLZLlRT42T
z9xZKWzkNU6dZbhm7E+rndthIn/ciz+xCnSG8J5l9+sX9nEYlvj0z7jDaMhh6imd
GQD5aJjaZwXvfVNkycJjRPePdYzWRgT2S6G0aD6wjqxnesfuvl9H6ov3p4gJXIJv
Xn340niuUiSP3/Pk5l3UvYLibOYhdasLXGqnuEtC2ms6i0NMsolMAImhnGz4gAHa
DTg0XQMbTE4QhVYuwQWzO84mco5sVm3cvSDvD+eq2TUMaCets4mz1DoK9XtYf8JA
FnmcCFP9crdpGA10+ro2udqRHyjFNr6nIHRK4O7h4vGzsaFA2bn/mehkXi2PoWfS
xEcpbAAUcW7niZo87gZOft5bH0lMLgESYUdgGGru6OhCJJAroQ47JbjID9+qRBAh
YFIHC1njrS44EJceef7tInV4N7wOGt6x3n+4tDb4rib+0MZ2MUEO1OgOqEYzYgDM
kC/PKAbb+j59m+wQu0q3us2am1ZvaUoQ/2yVbwLNWXh5smPfqE0nE0RiKQ18knzN
5ivRSK0fn+TK+dKAH6xJ
=r1aF
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Apr_2012_11_20_49_+1000_QK4cBF33qfYUt64k--
