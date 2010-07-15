Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab0GOXve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:51:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37878 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933992Ab0GOXvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:51:32 -0400
Date: Fri, 16 Jul 2010 09:51:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs-client@lists.samba.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20100716095126.e084dde0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jul_2010_09_51_26_+1000_LqgdqtRqq/phIJLe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jul_2010_09_51_26_+1000_LqgdqtRqq/phIJLe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from fs/cifs/cifsfs.c:50:
fs/cifs/fscache.h:49: error: expected identifier or '(' before '{' token

Caused by commit 07be494ba2f46852ec6d1faab8111f5179cc7bb4 ("cifs: define
server-level cache index objects and register them").
CONFIG_CIFS_FSCACHE is not defined in this build.

I have used the cifs tree from next-20100715 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Jul_2010_09_51_26_+1000_LqgdqtRqq/phIJLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMP57+AAoJEDMEi1NhKgbsjD0H/Azg82a6Tvh/HR0uhOfsqx1F
6eK7OrIqVV/ik+LOjV338iFdy5dh+xwOad4po1U+F/tbrBHbtcN+8ad1VaKkMAaR
VthMfMt5bNB2Gzd2ZZlcjL46YSFzsgUgEIoUn/QPHX+rQtH9U47OuQJRKNFZ/T8z
jBc7yGNJOhNltHjeRWXNgHhsxqO9mYWk6DRQneaH/mKRPnYixZBgwoTwIRcbU9Dw
NQFSzGY2Hs8WwA5N/SKitWfsVY/EASsaxtQWob6D2YE1KIt8giPGcvM9qeFy6D24
DJCz0Wsqu7MD+InLvYIcaowwoCcAls66ZjM+OwlRMfL8izRfHwD4qX+vNC2vwRA=
=xOTi
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jul_2010_09_51_26_+1000_LqgdqtRqq/phIJLe--
