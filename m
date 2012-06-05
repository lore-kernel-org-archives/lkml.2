Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2FEMvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:51:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:18335 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab2FEMvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="153125060"
Message-ID: <1338900917.2507.50.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] MTD: add JEDEC ID for w25q32wd to chip table
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "ing. Federico Fuga" <fuga@studiofuga.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 15:55:17 +0300
In-Reply-To: <1338900730.2507.49.camel@sauron.fi.intel.com>
References: <1338478732-31992-1-git-send-email-fuga@studiofuga.com>
	 <1338900730.2507.49.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-b2Pqr3kmW0lMDCF5K4Hu"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b2Pqr3kmW0lMDCF5K4Hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-06-05 at 15:52 +0300, Artem Bityutskiy wrote:
> > +	{ "w25q32wd", INFO(0xef6016, 0, 64 * 1024,  64, SECT_4K) },
>=20
> It is w25q32wd, not w25q32wd.

Gr, "dw", not "wd".

http://www.nexflash.com/hq/enu/ProductAndSales/ProductLines/FlashMemory/Ser=
ialFlash/W25Q32DW.htm

--=20
Best Regards,
Artem Bityutskiy

--=-b2Pqr3kmW0lMDCF5K4Hu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPzgG1AAoJECmIfjd9wqK0nYUP/iWs69HQaYDtJvxOm1uaTKtt
XNyckYSRpxEFCS2uqsYrA/27xo98IYUeadtYaPwXeyxl9Ovqv61qJdUhgGeUfmXp
jBnaitQeLsbajTaXb2OzdQVifg5m8BjbAO6Dpi4onCuXcARo/hCPTmTnZp/kdXv/
IE8hPCI+m7yUsMesJbFcYw2pInNfi+NOFlHDa96RvUi4oGd6A3pK+hP1dzh2eFbI
Zd3rAaVinU4WtiXznNc+S/M0RDVxQu8A2PEyXrhLgb5Q6G5vSjilXBrgzxgDiGgx
hsDhnFzUsQ3YlbQ/4NahnP9+lgqZDBblug13+6sIjEuIxVdMMjey46ddCN4JbxHh
yG1hNel5DTn/3pryzd8hSMyVkxDPCtOee3JYwEQz8bnLO+dUzKNsj9bw5kn8iAsk
a1IkTW8MsZ4r5FO5p7sMj/127vz+vAH6BkpyyUvOonFUb748W7eh2Fj+PQcQUXaF
Y6jBIC5O1r94IPWxearycGXnkrAwOw9UpkHZJCnubAGPzgnA1U9zId0NesoR8Dr1
XdXpSnbKWwaTIQo2RA1XaBH3gu20xjO98euSn060JLIi3O4QufZ6h3A3NmmNnaLU
z6pIDmXhDDzLfnqYbm8SsdA82l67LPlv9rHeDYExZBPY/e9ROLsSko5pyWDjHIIW
LGfQuV+5fWn/SFVkj1xq
=OZxw
-----END PGP SIGNATURE-----

--=-b2Pqr3kmW0lMDCF5K4Hu--

