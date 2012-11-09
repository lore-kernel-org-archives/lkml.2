Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2KIPKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:10:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:1230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab2KIPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:10:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,746,1344236400"; 
   d="asc'?scan'208";a="239538057"
Message-ID: <1352473841.1814.35.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: gpmi: remove unneccessary header
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: Huang Shijie <shijie8@gmail.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 09 Nov 2012 17:10:41 +0200
In-Reply-To: <508B4586.4090600@freescale.com>
References: <1350147809-19616-1-git-send-email-shijie8@gmail.com>
	 <1351258892.1823.20.camel@sauron.fi.intel.com>
	 <508B4586.4090600@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WYpBHUCrzl7YdTg67Y8r"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WYpBHUCrzl7YdTg67Y8r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-10-27 at 10:23 +0800, Huang Shijie wrote:
> =E4=BA=8E 2012=E5=B9=B410=E6=9C=8826=E6=97=A5 21:41, Artem Bityutskiy =E5=
=86=99=E9=81=93:=20
> > On Sat, 2012-10-13 at 13:03 -0400, Huang Shijie wrote:
> > > The whole gpmi-nand driver has turned to pure devicetree supported.
> > > So the linux/mtd/gpmi-nand.h is not neccessary now. Just remove it,
> > > and move some macros to the gpmi-nand driver itself.
> > >=20
> > > Signed-off-by: Huang Shijie <shijie8@gmail.com>
> > I cannot compile-test it because the MXS configuration file I always
> I tested this patch in mxs and mx6q with the linux-next-20121026.
> I do not meet such compiler errors.
>=20
> I think the l2-mtd tree is lack of some patches in other people's
> tree.
> In the current l2-mtd tree, even i DISABLE the gpmi driver, the kernel
> still
> meets the compiler errors.

It is based on v3.7-rc4. Once the patches you refer are in Linus's tree,
let me know. Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-WYpBHUCrzl7YdTg67Y8r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQnRzxAAoJECmIfjd9wqK0Bm0P/RbBnqyO69W/ZXKXxyyCuwLM
fw/HiNUXM3QrgE2SYaZ0IBoXKbkdZ0ZtJl5r6ZRVKRfHA/NSQgmXEIcMdbTz0Zbq
+YjPjQ4bw4bRb/pdGcd0EcELvxA+/xgbvt3bjTWYbHknDlPQchcpaY8GCIhtDT0o
hvyMuuekERZi9f/fCkEZeQ/iHdr7SXfQnOe8R6+CZUSWvPBJz+Gf1T6HJkijKQeR
Yiufix/hpaMwaxEgxhLgTpDmg31FzlB29S6QQ2FbCtDYkSDpEj2ZARdaMGMh98v4
b0gxhKb+fIiuvYqBmSMnJij1nXdmQqtesq/AyFdF79P6cDvjxpzIUXG7TiuKNkFZ
Tz4V0IHbdj8RhM5D3N5wUkkb4yhoPJ8umJmIHCWnYGZ8tR/kHe0ZIdPRmb12RNs8
KexM6sVREe+okJawE4zqjfD5Qk/RlhJQ2RykZq14jUMSf7rYFpnXDsUu4psas4kY
+JoRX/cMMgnLl/FQihiVo/MJBvlSFkRPVroNmKnIIhoLijY/O5jISGJ6ve+YnNEC
hKKOlGpmkh7unuEZXjms6V6SXA1Z9hqayeo7wXg0nCbUtKtOEFIKoz08KM9AQUDz
GLZLlMTpI8ABnmR0jyBb3h1xFMPSVV2ds9QAYsV3sJPovlXK9LtxGQRYjUv3sm7S
p4hef9YHEexlmqZlOa26
=OJI7
-----END PGP SIGNATURE-----

--=-WYpBHUCrzl7YdTg67Y8r--

