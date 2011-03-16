Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1CPGu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:50:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55153 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1CPGuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:50:52 -0400
Date: Wed, 16 Mar 2011 17:50:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the final tree (ubi tree
 related)
Message-Id: <20110316175041.67c4f371.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Mar_2011_17_50_41_+1100_sK/33jNIqrHlMsb9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Mar_2011_17_50_41_+1100_sK/33jNIqrHlMsb9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mtd/ubi/io.c: In function 'ubi_dbg_check_write':
drivers/mtd/ubi/io.c:1348: error: 'PAGE_KERNEL' undeclared (first use in th=
is function)
drivers/mtd/ubi/io.c: In function 'ubi_dbg_check_all_ff':
drivers/mtd/ubi/io.c:1412: error: 'PAGE_KERNEL' undeclared (first use in th=
is function)

Caused by commit 823ed5091113 ("UBI: allocate write checking buffer on dema=
nd").

I don't know how to fix this, so I have left it for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Mar_2011_17_50_41_+1100_sK/33jNIqrHlMsb9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgF3BAAoJEDMEi1NhKgbsXy4H/2S0dcFSLT/PEKRDUuAzUn5s
U6hIcjOTRE6ZqSbsjyb3x7yodg+m3f36K9bqbbpXe3yoAU0nlLpQwBy7QQCuLx4n
YP0h/a2KedulYf2LHBf+jCI+tkfTYTLPxsoc+L8wK8Comu/lf8FONPXhGGLGVbhD
a70IVo0P5ZkQzpJnyY4hIQGr1oGPkj8fLnQjv1JRpCD06AgNS9FRcFL7Hoq7cdoi
pjbTT3V7nYL8A4wMmQz6mcifig3681CsrQAr0AT7YuJBRHVgUJHqHhEtNrV8t/lu
LCG1Mt6oVR2VeTWgvVMCGtaDAA3c61SBXSsTTCmiijery07r8GOOtgUU3GugUPw=
=7r7z
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Mar_2011_17_50_41_+1100_sK/33jNIqrHlMsb9--
