Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2B0HNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:13:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53767 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2B0HNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:13:12 -0500
Date: Mon, 27 Feb 2012 18:13:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Kelly <ckelly@ozmodevices.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_18_13_03_+1100_nd9R5BC0mmtwd36M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_18_13_03_+1100_nd9R5BC0mmtwd36M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build
(powerpc_allyesconfig) failed like this:

drivers/staging/ozwpan/ozcdev.c: In function 'oz_cdev_ioctl':
drivers/staging/ozwpan/ozcdev.c:284:7: error: case label does not reduce to=
 an integer constant

Caused by commit 23af8c2a088f ("staging: ozwpan: Added character device
support") from the staging tree.

I reverted commit b0406db5b3e4 ("staging: ozwpan: Plumbed in Kconfig and
Kbuild") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_18_13_03_+1100_nd9R5BC0mmtwd36M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSyz/AAoJEECxmPOUX5FEJZ8P/j0JSnkJT/JLQtIGXoFQENKp
DY1J8K51kf3Bp5CO57VuSTj1L9Ig83i39NCtBg2MXpUI+QBYfeQY87N5Xs44w3uH
HCpg7LiCZMTdcsNWCmZuf+Wx06BbrXrdU0KwQBoM9mnHP8685/dYccrd4wrlEObJ
UqYoeBeRJqrucJtrc2Vop2gLtePy42T7vjntkcVumJiX3Md5JmhAYKYLVmJBCjI5
QLT8iU5MCiEh/5l2v3DDiqG+FnH49KqU+OxXIJOIdSzMjh/Sfqf5iWRvjqxS6zQo
FvDDBrKfw8G8ADTfAPePU+07nRsNwy3t4Bi5PoX5E9cFDjf2G9m6ZNDZKfiFiBBm
bIZOHJ36lkDS20zvB9N064qlCbOT5ugwUg2cpMVk4jp9LsMTEQLJb63u9NDjfuYJ
kDJcMEla9bbyu4CH6PjTnS46KbxmX9bbbNZ5/zLFp7HvgHjxnhTPltRpUQ8AX9pD
mS4cUdmn1BOMN6FqpyfVVYHMR09O+KBKlqiZ7JD9qI2bCXi2fDA2mQIunfA6LqMH
erO3Ie/ePscxfBaKs02v2asm5QtAhWqLkV8ouCi2L1LlnLbRgi8W2HLGGDM2WpVs
TKqiXzbVZGmbPQRDWUhqMVNAvcjyFJl7NnTMfqz6in6dqLLELNzKus8ul3xW8CGS
aojRFjba1y1Ms+8dEyzc
=o9WG
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_18_13_03_+1100_nd9R5BC0mmtwd36M--
