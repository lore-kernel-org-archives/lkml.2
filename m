Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2BCE4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:56:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41808 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BCE4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:56:38 -0500
Message-ID: <1328245104.6750.6.camel@sauron.fi.intel.com>
Subject: Re: Crash in mtd_cls_suspend because mtd is NULL.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: NeilBrown <neilb@suse.de>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 03 Feb 2012 06:58:24 +0200
In-Reply-To: <20120203105057.11a86f26@notabene.brown>
References: <20120203105057.11a86f26@notabene.brown>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mZA86pOD/5wmHDJIDvZE"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mZA86pOD/5wmHDJIDvZE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-03 at 10:50 +1100, NeilBrown wrote:
> Hi,
>  I just tried to suspend my GTA04 (OMAP based mobile phone platform) runn=
ing
> 3.3-rc2 and it crashed in mtd_cls_suspend because mtd was NULL.
>=20
> So for me, it looks like the following patch is a regression.
>=20
> Is there anything I can do to help find the correct resolution here.
>=20
> (It has some flash memory but I am not using it at all).

Neil, there is a fix:

http://git.infradead.org/users/dedekind/l2-mtd.git/commit/da50432777e184dd8=
89f077cf06a74aa24cb80d9

I should just be merged upstream. It was discussed here:

http://patchwork.ozlabs.org/patch/138551/

--=20
Best Regards,
Artem Bityutskiy

--=-mZA86pOD/5wmHDJIDvZE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPK2lwAAoJECmIfjd9wqK0UgwP/2Ae28/wunh9Hgz49ZgUd/8i
RsYz39PoxI0inUA7nIUdSPQBFt2FsS53KYWcN/sGe2oj9b0aM4Qv9OxnlM5+oG68
mTm7NwxVV2L30GR1pDYcbMohpfAwCT1BwpAj2Rz+XSRai19K4EjY0MFTKE8lN79f
V/zNCwaj4Ysm2wo70+HaKH56NYowVC0KPg3lgaQpjMyFFvb09fK4/UrtkYCruptg
rFsUav5879PpDus9iZMxD9nOUwznfJffpYjIBAEboPLpU4F8yf7Y1Pb14NxCwnp7
zCVJxmzjJBQuy4vnL4wCs6JjUNGeDU8H1QtE7OwegZjzmwgZcK9qQfI23rXJxIXB
u3WrgBrel/OH8B8E+sWrQ1HJshskT0sriMv4eJzOsbEZTbP78LKtK7asANozsckO
NGh5AeZJiWEidZ6t3Xouc2nOWxagZugMe4Rd8AKc4hDrObOvtAEoq4orivXJsoUu
Kcv/ZIDyYpLswgpXRIaN8XgJ7okGZ+Ao3DlIByNxdZwPTspf2QfxbbHARMHGD8NT
pIqAJcT6zJs64MbH74/5MpO6pIx5BqwwBHWtbDtggKVjpAV/qNFcaM1qXt7D0sBo
tvbZLOtH1KyQkO61xE8irD/C3D5tDW3sJ4/FBWvRZPtKV21AYh3wpc1C/Ev0auIK
KTaYpj3vn4mB/E3Ws4Uf
=8oII
-----END PGP SIGNATURE-----

--=-mZA86pOD/5wmHDJIDvZE--

