Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1CHBIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:08:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1CHBIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:08:01 -0500
Date: Tue, 8 Mar 2011 12:07:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Filz <ffilzlnx@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20110308120753.8adb3ff6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Mar_2011_12_07_53_+1100_Kv6gVELRy4XmCOHp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Mar_2011_12_07_53_+1100_Kv6gVELRy4XmCOHp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/inode.c: In function 'nfs_compat_user_ino64':
fs/nfs/inode.c:93: error: 'compat_ulong_t' undeclared (first use in this fu=
nction)
fs/nfs/inode.c:93: error: expected ';' before 'ino'
fs/nfs/inode.c:100: error: 'ino' undeclared (first use in this function)

Caused by commit 5fa1ca22302da56ffa568e847100e80be90cc602 ("(try3-resend)
Fix nfs_compat_user_ino64 so it doesn't cause problems if bit 31 or 63
are set in fileid").

I have used the nfs tree from next-20110307 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Mar_2011_12_07_53_+1100_Kv6gVELRy4XmCOHp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdYFpAAoJEDMEi1NhKgbsqkYH/1zoeijluaTx+7nn/2NsS63D
BqaxW4MezzwXedcGj1xi7PxGNAkojCBe58PXvXk05OXw0KrE1RW/yFyqW3o7M8PI
aSRC1GU+bW6fGz8LbYdJDHhgjo0b5yqDI5tYAeyz6srylt76XvdXmwS2jesE17Gb
AwONZwtuXVEzgXZL8KJBIzPrPBwuEaREp7U3T3I5EQ32iGk9RW05xbCm6FrjmP7G
6AYkOpfzpi5mjErk6natecEGKsTLcQHpMcvVBKG+YPQx6LpgqGXycgbbmhr922bO
XO7DuvJT+DXAB5S+w9/TV6bKn/qz0OWCi6Fz/ePSOLYCVqoS7FIRh7KLsXFTER4=
=78rC
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Mar_2011_12_07_53_+1100_Kv6gVELRy4XmCOHp--
