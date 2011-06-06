Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1FFDEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:04:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51896 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab1FFDEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:04:24 -0400
Date: Mon, 6 Jun 2011 13:04:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
Subject: linux-next: build warning after merge of the final tree (vfs tree
 related)
Message-Id: <20110606130417.31af3b67.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jun_2011_13_04_17_+1000_ggrdNX4mhxVjPx6c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jun_2011_13_04_17_+1000_ggrdNX4mhxVjPx6c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

fs/namei.c: In function 'do_lookup':
fs/namei.c:1223:19: warning: unused variable 'old'

Introduced by commit 8667ed80ccef ("fs: add a DCACHE_NEED_LOOKUP flag for
d_flags").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jun_2011_13_04_17_+1000_ggrdNX4mhxVjPx6c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7EOxAAoJEDMEi1NhKgbsdygIAJbqpnXoE9tbXskdOnPb/R6+
aEm2MoVyEL9ske377C0HDByGaKX+tR/AzbQL+E/GDSbYvzxichQinh/1mnDBCmeC
CthWhI2F5KTq1pYn/7rRxxyNp90ofzlNb9bSPB/8KwwPOHt+WKOZmnaSILBrxXoS
86WKaIRmHOpVn8klgq236w+f+SFDhMhEliBi8WDaMGniSoFoAO+Ig6y2lNL7qUOL
rSDCDObR2SNzpLarFoVwluoSUFMg+D5mh0h/KfBYGB+55t3U4JUdYIujoVlEToTx
2lkdU6IXUbcgA3eaRNOt2/2DOmcc0bdi81glHtIP2jI8K1ho2O5BaOj/T93A/KM=
=iSwx
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jun_2011_13_04_17_+1000_ggrdNX4mhxVjPx6c--
