Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2KUPBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:01:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:19087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab2KUPBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="asc'?scan'208";a="245362041"
Message-ID: <1353510137.2701.6.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd_blkdev: Use a different name for
 block_device_operations variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 21 Nov 2012 17:02:17 +0200
In-Reply-To: <1352475395-11917-1-git-send-email-elezegarcia@gmail.com>
References: <1352475395-11917-1-git-send-email-elezegarcia@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bkYF5fBXMznKPCBKxCZ/"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bkYF5fBXMznKPCBKxCZ/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-09 at 12:36 -0300, Ezequiel Garcia wrote:
> struct mtd_blktrans_ops is a type, and mtd_blktrans_ops is a variable.
> To improve code clarity it's better to not use the same names,
> so we just change the latter.
>=20
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-bkYF5fBXMznKPCBKxCZ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQrOz5AAoJECmIfjd9wqK0lCcP/1eo59nE5zhZpdqBA0JtILFS
0pFSqF638rxjEtX7RaQERW7vsweRuQlyf4pBd6URvebegr9DnvyN/3HzaofKRD5B
hPHiAog0r4mRIFFZaF+kSy2DmmVV1x8nw0rPTGNy6QpNyVQy70BvD4T46UFLYDb3
JuRQCUDqrjHPlpkuWxQ/ogJ0cN6iy+fFJIk3LgQf6MvVldco8czTnIt8T2007e10
Gl1r68EHQROV9mvjRv8oEl/ec5CTATU/IQA0dp7An7BCkJS8/pDUJTa4vQY6QQgU
NJwc5NXJgoTpNcU1T/OJ9RFuLo8mO5yZ4Xq+E2FPkiCJLuSLGU39ibOpiGCdhkSP
E9XjqKqZrfY9z5mJk0sO52FbFls1KUbj5fc2VQfEmXc/U/4gTiri2KsvOeY3ouL9
9OcSbTp3PtjBu4pD31pUtIiNIVNxn6UFm9Pf+DotPFsPwTuK59cEvBG8hG0A0CS2
XJG05G7cRfuYmwFP0ueNH072+FAvbIpOh0cvpK0GgD7oy4us3MdkksWXi+P61j5C
Bw2IWV175pFTZ4Khfo9Ff43ims0B+fXv43gXjDtp0i/czC55korc2Fz5Y57cpbMx
QRCv8E3i8be205s1Bua4gUXGv+kP44bgIwoG0CaNBLJ23yPKrEtUYUj09P1t6Qgu
lbZe3YdmdeBTf/Rzx8Wq
=bprf
-----END PGP SIGNATURE-----

--=-bkYF5fBXMznKPCBKxCZ/--

