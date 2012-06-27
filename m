Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2F0MyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:54:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:36579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2F0MyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:54:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="158770645"
Message-ID: <1340801874.3070.0.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: chips: reorganize Kconfig help on swapping
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 15:57:54 +0300
In-Reply-To: <1340106762.1936.25.camel@x61.thuisdomein>
References: <1340106762.1936.25.camel@x61.thuisdomein>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Z0lzSNEx9hcCmM8Hmsg4"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z0lzSNEx9hcCmM8Hmsg4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-06-19 at 13:52 +0200, Paul Bolle wrote:
> The Kconfig help on "Flash cmd/query data swapping" still mentions
> LART_ENDIAN_BYTE. That option used to be relevant for setting
> CONFIG_MTD_CFI_LART_BIT_SWAP. That option and macro got both removed in
> v2.4.11-pre4. So, although LART endianness sounds intriguing, that part
> of the help text can be removed.
>=20
> And, while we're touching this choice, move the help text up one level.
> Currently it's available under the "NO" option, while it's relevant for
> all three options.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Z0lzSNEx9hcCmM8Hmsg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP6wNSAAoJECmIfjd9wqK0plcQAJC8bxFnzluDgQVBaYoV3cSU
XtI6W1ENBYsPaY9cX2NPTIy9BaXyp4TddtOutarn1r6xyP4+56tu5crQod7XXVcQ
Ty1HooKJUAv7Kg2jJBiXOa9GvHLNHRSoH68AviV+f4hk/cF728rFoHtaEaw//eVd
oYpVR1wH2COxZjQSRv5TH05rk0JrUuXPXwQ04rk3svti5rpM1W+/bZIYvWeVQViJ
7a0Xu2wyyCWqEhga2ox2YnwIBTvep76UNancuFpqwqRuXPlI4QCKhLoXeJeQY8Hw
w4O7aO4ib3a9SjLituS2fBkFHojBxdZFgK+8GVtIe1WU7lmtl5l0r192ZpP4yeap
MkOdOgL7WtMaCrdzjDIlvvTfF60A0acRY8fE6bLStd/zFK9otL8YhQdTguyBqq7s
qgDMF1u2AMDQSIaCWJ/BhJj0YH27gkRyF4vreBDMFQ0ZcEcaw3fw5y2MuJSag73r
Gc71IFiuX/hKk0HcslIt+YIfEIHBUwjkIUubLBgtVuWguKyoGhQdmSYCsIR5rqlv
ZVMwxvS+wgZar8SeK91ZTrd1NmzqpurL0WG7MSMzN6sFB1h3vdnG11J2LfAlQ0iq
u+Q3t74nE953+reVvEPGt8PjXp0W839Dtb9VVI7/L0FyU3coM+JjrgvMSH+dvMNM
8iXH4jrexlnNxdSRjedB
=0pUi
-----END PGP SIGNATURE-----

--=-Z0lzSNEx9hcCmM8Hmsg4--

