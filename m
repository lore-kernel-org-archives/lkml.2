Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2IXJgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:36:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2IXJgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:36:50 -0400
Date: Mon, 24 Sep 2012 19:36:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Venkatraman S" <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the mmc tree
Message-Id: <20120924193644.c62d7e91dc2a3f206af9fb65@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_36_44_+1000__l0qcyOK8l/qX/7b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_36_44_+1000__l0qcyOK8l/qX/7b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mmc/host/omap.c between commit 2976837c6ea8 ("mmc: omap: remove
unused variables and includes") from the mmc tree and commits
cf3a6ec2c0a4 ("ARM: OMAP: remove plat/board.h file") and 70c494c3122f
("ARM: OMAP1: Make plat/mux.h omap1 only") from the arm-soc tree.

The former removed a superset of include files, so I did that and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_19_36_44_+1000__l0qcyOK8l/qX/7b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCmsAAoJEECxmPOUX5FE7Q4QAKhmb3GXHCj50oq2+n3u7yLs
VhIq3MZwYZELYighXHJcVTizGAAwe8U4jpjfKN2TCspubbWSy5fwqlnR1q0BcGzf
lL6JsFgg1ycXQiDKoeqh7B3EZqArL3n5wK21b1AUOUsAc9mFa1EWJTD5MCrr4lFb
127M6cVuRSbmfO9PJwbZqKQBvp9rVmFyT0Of5QcitZCTrfZiiYCDPupazVxNYS21
1z/b3+OARZRz31hHESu+g6on2vMYkApYbXdqh5dzewVSg8solox0jrPllw1xch0U
wEQrgKtAvwFDsRZWKHfD5MRZolXY7uGmZ284bCUjv78mPFPPOh7TX9oN8smZyNqT
ZfsD+nK10VTNNv7Y8LHjoNowHs8C9rb3suNBOwtVfOjYkgvxmFoaXd6wkdJZk2A3
XqEJSoEERnKGyJVit9MTXcf4+yA97Eg2gwfO0V9GDKtXBvgPGmsYRv1J/dKLcc7C
MzjKvCR4JK0lNJb4tHCo9cU95c/V3nGQGFe+Ju8sVKc2k/lLliYXppNo8YkQqEBe
I2UHSvpJwLs/C1VwQOhkIWH7L0SUbcGdL8nauUNSii1HW2J/RIT4ttV7uFcd7RSX
o72dImyg5oMxbXh35j/HDJrq7AR8B41qce0A8mrinMiesIHsLc7oyq1Rm+L5+fgs
f0VkaQSuAwFjY1ZSORrU
=P+FS
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_36_44_+1000__l0qcyOK8l/qX/7b--
