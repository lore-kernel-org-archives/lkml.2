Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2HQJ7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:59:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:10348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2HQJ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:58:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="asc'?scan'208";a="181889094"
Message-ID: <1345197819.27859.38.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: failure test for null
 rather than negative integer
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, Stefan Roese <sr@denx.de>,
        kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 13:03:39 +0300
In-Reply-To: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hdjZsFlsIaO4WAkAOnID"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hdjZsFlsIaO4WAkAOnID
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 10:58 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> dev_get_platdata returns a pointer, so the failure value would be NULL
> rather than a negative integer.
>=20
> The semantic match that finds this problem is: (http://coccinelle.lip6.fr=
/)

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-hdjZsFlsIaO4WAkAOnID
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLhb7AAoJECmIfjd9wqK04nwP/3aqz01ZcFM5HZLsJnWjsizQ
wBirufEH6EJVPkrEmI82+n5t40Fh4ku/ewnktCjU+SMA2ovj5BUnxJgUVlCo+ToA
DUwJ05TYmr+n3Y6hAnZjmpr8f/igIQCgkUkm3NGUs/oXMg+sbChXX3IgSTqpACWX
IR84aTqH89L8syQFU20RLsHFCH8rHpP6VrjW6OpLFZN5R+4G0dtBNhDwekrRoxwG
vJLgksG1KR5wcNi2vrVt8qn7tmYLVZLIn12I69K+2ZKdgmC8LPJX2GVZrA5trVDb
hpqA25g/larcxMQibdt7leLwt5oloMdwN+Oe+wlFSFcY5ONK7Tc5xrOqEC7E1nqY
ZsGFHzvGMJ4dNlljE0UUkj7uvf5WUSHZubntRwK3sekBkgigIgZKWgTAW+Kpn8JP
TvZR/JFEf7zSX3vlsLVBBoc63SZm+ctcvCC9HXK+y+czw2t9FTycPUlCyYlhNkT6
33txMVQXO46SvK0triatYhLA1x5oyB3K1i3OiQexhUpAi6juQ9Sg4Vh7PKZxDBeg
7LzlPc0f8YSFyh4PtbEF7zaCAa+dQ/yJwn/d+hGT4P9VXf9cnIlbga4wt68BtyCh
0EOxDzBGGcRRq9HQL6YkkeYT6va3kyNNu+dr7OAAun4/iQFiQAZokIsHZ0B9fO4g
LbKlTkRDOqu7ptK09cyY
=msXB
-----END PGP SIGNATURE-----

--=-hdjZsFlsIaO4WAkAOnID--

