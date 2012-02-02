Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab2BBXpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:45:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2BBXpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:45:04 -0500
Date: Fri, 3 Feb 2012 10:44:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: linux-next: Tree for Feb 2 (fs/jffs2)
Message-Id: <20120203104453.8438182da9f365c24d3c2128@canb.auug.org.au>
In-Reply-To: <4F2AD4DE.7040508@xenotime.net>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
	<4F2AD4DE.7040508@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_10_44_53_+1100_KPBENjOXy6lr7v/K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_10_44_53_+1100_KPBENjOXy6lr7v/K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Feb 2012 10:24:30 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>=20
> fs/jffs2/*.c still contains uses of ->read etc. instead of using
> mtd_read() etc.
>=20
> fs/jffs2/read.c:36:8: error: 'struct mtd_info' has no member named 'read'
> fs/jffs2/read.c:112:8: error: 'struct mtd_info' has no member named 'read'
> fs/jffs2/nodemgmt.c:669:8: error: 'struct mtd_info' has no member named '=
read'
> fs/jffs2/readinode.c:83:9: error: 'struct mtd_info' has no member named '=
read'
> fs/jffs2/readinode.c:676:9: error: 'struct mtd_info' has no member named =
'read'
> fs/jffs2/readinode.c:954:8: error: 'struct mtd_info' has no member named =
'read'
> fs/jffs2/readinode.c:1040:9: error: 'struct mtd_info' has no member named=
 'read'
> fs/jffs2/readinode.c:1216:8: error: 'struct mtd_info' has no member named=
 'read'
> fs/jffs2/readinode.c:1275:10: error: 'struct mtd_info' has no member name=
d 'read'
> fs/jffs2/scan.c:286:8: error: 'struct mtd_info' has no member named 'read'
> fs/jffs2/gc.c:590:8: error: 'struct mtd_info' has no member named 'read'
> fs/jffs2/gc.c:894:10: error: 'struct mtd_info' has no member named 'read'
> fs/jffs2/gc.c:977:9: error: 'struct mtd_info' has no member named 'read'

They were probably missed because they use the jffs2_flash_read() macro
in fs/jffs2/os-linux.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__3_Feb_2012_10_44_53_+1100_KPBENjOXy6lr7v/K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPKx/1AAoJEECxmPOUX5FEjfMQAKkQBMSZ1l1DbYtAXeqWSI74
gTF0UQn3Ejj6yQr9VlQRzBik46yxhSVsScvVZ6waIVAN/m3KVMyjninNm5LMdaWq
rni9lCDUFXUTKQwZCtmTpyNQHxm4ua62xlH4wuWS0+YtS918XEpR8cnDoQHEYTO9
kvhWf4X8tZoGzboBeCcKMH9TcA1WhEwnruVZ+jG4OF1QTvbiANss9dZxTe56DpnM
ONRBqglftu+O6qpv/JIbxYZ6bKVyRJt7LU4iPKDi9qK2qgC1SJ83zSFq4BCGPjHs
zoShD2rBfrNX9RRjgOYNeiUI+mGj0XVIt4oTQuRyzeA018xV5F7ep/OsFBSGfaYa
9RqkZXTcBNjQ/xI7JB86YHrRjd/p3IHliYLfZ8jx/+v09Q7rYbC/rlxCdvvYz9cT
D0nQ9qYme6AJAwx1alFv1ZOnJ2S/cOz3fM4MK7C9vJDdNsAXzOJN4u+o8DB2eddw
GZR+ejy15WmgKVluIJi9XVOYKfGPgok6tILhMB3cC7YDz0op0KvXyrviO9HWBDJb
IYgRWOnT9cus1Zk8ZcIJ3p0La/mE6RZhmFuJV8yb19/nw5ckuI4U9cpG6gsAGyoW
IzGZOvuhg/jNleRX1Y9osJUmNOrfmUE+3LNl2f0RbDai2TiqyRdV5EUAD+WtH0bw
sI2pkGkPKTdndIfyK0AQ
=Nl48
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_10_44_53_+1100_KPBENjOXy6lr7v/K--
