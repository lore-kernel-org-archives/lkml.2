Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab0KSCGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:06:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60365 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0KSCGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:06:05 -0500
Date: Fri, 19 Nov 2010 13:05:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the bkl-config tree with Linus' tree
Message-Id: <20101119130552.2f195494.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Nov_2010_13_05_52_+1100_LXKCA0lslcEBQpB6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Nov_2010_13_05_52_+1100_LXKCA0lslcEBQpB6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-config tree got a conflict in
arch/powerpc/kernel/setup_64.c between commit
0f6b77ca12bea571e0a97b0588f62aa5f6012d61 ("powerpc: Update a BKL related
comment") from Linus' tree and commit
bb2d384ab8184eb7f7146897e47fa5b38583112c ("BKL: remove references to
lock_kernel from comments") from the bkl-config tree.

I just used the former version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Nov_2010_13_05_52_+1100_LXKCA0lslcEBQpB6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM5duAAAoJEDMEi1NhKgbs1EcH/2FqhEYGiaTp2Hcqi5sy/BaZ
MGJyxMM+8Rwd6iLZl7kPgDznFvL0yCX99I3KxJB2rPq3ll2s6+OTbvj2PxB5SzFg
cTCXar/MngyXHc9/iy3duRc6cV7v7eWtyZjzXYe5iHKp+7ios1vJnqvexRKT2VHc
8HoC6h9D4JLAW7Q0+xMSTRh7qoZf0l4wko2NnRZd9B8vGEK5t3Ga/DUZOfRpP6HD
Nxhmk9hR+mq4Q7YaJNycGr6gxQpWl/lujVVlgBe+F9hwMfnlyv/yFJr68rzrUmtL
lpJU60RhltfnG91NSSt9furMvzh0F085s7fZ5gXeZcNs/yxclVa89s3jzGBgi/g=
=cdUB
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Nov_2010_13_05_52_+1100_LXKCA0lslcEBQpB6--
