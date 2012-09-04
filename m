Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2IDHpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:45:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:48207 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2IDHpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,365,1344236400"; 
   d="asc'?scan'208";a="196369564"
Message-ID: <1346745025.12610.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] drivers/mtd/maps/autcpu12-nvram.c: drop frees of
 devm_ alloc'd data
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 10:50:25 +0300
In-Reply-To: <1346517191-8794-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1346517191-8794-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bStECJ1vZZCxIlkGac+M"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bStECJ1vZZCxIlkGac+M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-09-01 at 18:33 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> devm free functions should not have to be explicitly used.
>=20
> A semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-bStECJ1vZZCxIlkGac+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRbLBAAoJECmIfjd9wqK0okkP/2E1NJ2Gmt9Iv+L9hiNdUesK
3dcR+sYG1eEP/Ac7pwvpSsP8LEa4YtW5XCgsYQ+3lgKiP/q95/eKB+mhjb3mea3h
Em3ykBMbT2a6C8MlsiIMtlz+tr6AfgYHK3HWu6/Ko9vEZCtfOE2xdISiBzD5mlDN
32yY+UJrYRE4+OlbsliJkRNZ3BKKR2BQwgFiFYU+LOxbxJTFwyPClb+Z8Y8KPY4F
VhO+IJd5eD/gvvWMz3us0oElHCRV3tmdSwNJkoNlZm2WehP+0cwUaa7s4QTHwhVg
a2vG9L/GIa2Iz0ctppX0si6wmZHRkp9K/nIgn9Q+sdEXU6fattVVF8XFLkzeS6zv
xmKXNykcB6QivLCGHTsTVBKce21FHMzBNpAobrksIBszsPXgJTK28Tv+Nw0aG6Of
tRFJtuKH5GJIJo8ElJB0mNRA0mi4kVqsA492AvtZWea2RVVAtizboTapfwYg+clH
CLHcwA0IxxHXSsVGfAIHKL1alrEJ0zU0QdtaOQ6fEf6aqie5ZoQy0achX5j0QI32
sr8qFvftwphxSrozRsOwVHzDytslU65f6wk6uY6ARcN3oX1O11mxSBelxq1EGuk3
dTUAjGwkpV7ARkgUMvlfJG/gjfeI0vyWCXQ0YiYb6ScGUr1iv4IfJCk4RfzbA3ae
C2o0StKIbaIJlF7o5vO8
=+ODl
-----END PGP SIGNATURE-----

--=-bStECJ1vZZCxIlkGac+M--

