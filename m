Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2HOOww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:52:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:32030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab2HOOwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="asc'?scan'208";a="186752242"
Message-ID: <1345042639.3393.150.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 17:57:19 +0300
In-Reply-To: <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KTfC9aqn+exDdi0EZY1t"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KTfC9aqn+exDdi0EZY1t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
> This patch provides the possibility to adjust the "maximum expected numbe=
r of
> bad blocks per 1024 blocks" (max_beb_per1024) for each mtd device.
>=20
> The majority of NAND devices have their max_beb_per1024 equal to 20, but
> sometimes it's more.
> Now, we can adjust that via a kernel parameter:
> ubi.mtd=3D<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]]
> and via UBI_IOCATT ioctl which is now:
> struct ubi_attach_req {
> 	__s32 ubi_num;
> 	__s32 mtd_num;
> 	__s32 vid_hdr_offset;
> 	__u8 max_beb_per1024;
> 	__s8 padding[11];
> };
>=20
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Would you please split this patch on 2 - first adds the kernel module
parameter, the second changes the ioctl.

--=20
Best Regards,
Artem Bityutskiy

--=-KTfC9aqn+exDdi0EZY1t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQK7jPAAoJECmIfjd9wqK0UUYP/3N1LiU5R430C02XisTY3uF9
qP5lQcjJaZB1abBiCa9/j4J9xKU+vjpG4Ya2n3xPQW9wswMceHlbE07JPo2b3Ov1
LSKwZphXvTP2F/iqra6gao1CPNkUvjU+FtovVA85GnS2U073kZdB9AcKKzMuxQES
YejSu7iibS9kYPQDdKqlbLZSKc/egWI8liN7S9ljLKFGVZ04cmgzY0AilEG8Mn/f
BbkM2SOFCYJrctFH5Fv7ZYYS9E0kHtAtuasL6yf9jdIVKmWj8eI+6A78tVuGQmd4
UMGkcHKw/CyEekD4QyOUI830042mbj/Jj4JM28f+tlDNokQqBtGkdfl4j2RODu+h
r23sC7r7jMT9QN2jET2CNMrj5MPBx28o4G8CL9maPr0VMQCCyo1ekvQJjo7p7vlc
ZKDLR993aSlvdqCzpvk9TdtbOsyuU23CC4Nk/6ViNKMg5vTq3TN01IysWmAwWx6j
oIM7PskvkgdUJf2L38UaK+ftVcrPXoqr2Lqy7FFOtvuBNQCvUZlJ8POGZIcKPlB9
rwdnA+Nl9ReOnNf7S2IACpqfZl7ouKwy08OsSKiykp1NSx8yjTw3rFJ1Tqeb+Fsi
XhCqVyPNsY8hOPOyExUeyff6z5Ws/ToCEXhNdgYpsdTyZS52C9VijtU10JRgu5BM
9oVpgmVNvW40ndb7nH/x
=J9jG
-----END PGP SIGNATURE-----

--=-KTfC9aqn+exDdi0EZY1t--

