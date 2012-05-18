Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031206Ab2ERORm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:17:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:6404 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413Ab2ERORk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="168115683"
Message-ID: <1337350869.2483.60.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v3] UBI: add lnum and vol_id to struct ubi_work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 17:21:09 +0300
In-Reply-To: <alpine.DEB.2.00.1205181538150.13472@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205181538150.13472@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WwtQI/bItoiUlPZpZPNm"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WwtQI/bItoiUlPZpZPNm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-18 at 15:40 +0200, Joel Reardon wrote:
> This is part of a multipart patch to allow UBI to force the erasure of
> particular logical eraseblock numbers. In this patch, the volume id and L=
EB
> number are added to ubi_work data structure, and both are also passed as =
a
> parameter to schedule erase to set it appropriately. Whenever ubi_wl_put_=
peb
> is called, the lnum is also passed to be forwarded to schedule erase. Lat=
er,
> a new ubi_sync_lnum will be added to execute immediately all work related=
 to
> that lnum.
>=20
> This was tested by outputting the vol_id and lnum during the schedule of
> erasure. The ubi thread was disabled and two ubifs drives on separate
> partitions repeated changed a small number of LEBs. The ubi module was re=
added, and all
> the erased LEBs, corresponding to the volumes, were added to the schedule
> erase queue.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>

Pushed to the "joel" branch, thanks. I did few amendments.

--=20
Best Regards,
Artem Bityutskiy

--=-WwtQI/bItoiUlPZpZPNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtlrVAAoJECmIfjd9wqK0PMwP/1FYXVcT3omAxdYSvfX56+4B
ChphV3QTRDRk+ooVGVzpZ/0N5oyacj9pEWwrYf9o+wCAaeuXgeSPw5XKmGicZ7j8
khhtx9z+b8m0pEODgsD9RlTXGGTRXwz+4tYiuQZJv1QtfvVD5VWfOvLilD/nDooh
9uEP5cGywi4MKBBs+apTh3+C5BDePNV12hlsvhocnsKSVKcyKMcjqQTq0SeEXti8
OimAGB6GBmyP4A8Ashlw4C/uEsXBZ6xWR3e89BBiXQ69ChLNwt4LrWnOrmh8UMt/
xfiXePsHUbX+T/zWkdYrlfeMl9pwK7AYVY50EbVOyQ/MVgQP7TuBbr02fUccfOZu
NkcBTrdz93/m7vO8FgHZhxlXc3HjDzb71YYl4Zw2o9Q4FixnuFmxJ0mcFzJGM8lZ
7dAWiF6PZOuuqJFSo3BDS4nElyrEkdtnAGtjj9sS0K7sqVaDPC3UAtZW8EgFGXwx
CKEK9Kt+VLhcUbhpd1JOliWKW5CFYQtpuuPqN4yyLrqRfDceK1jZZzNsWKurFHlb
BvNePYaQfle5EWPI06pL/6tZnyIzvB6Ud9kCD/T1jM/fwYwpdfzO04mTj5+8TgQ1
kkw1sD3UcJEPiu29AfmsfVIM4yb80d3lItns1VwncB5y0guUgHIhfAMG61AbO0J3
fROXaaYTHINehIfGeGwe
=AXY7
-----END PGP SIGNATURE-----

--=-WwtQI/bItoiUlPZpZPNm--

