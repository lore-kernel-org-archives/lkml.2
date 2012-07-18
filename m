Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2GRQE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:04:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34758 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2GRQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:04:24 -0400
Message-ID: <1342627126.9105.1.camel@brekeke>
Subject: Re: [PATCH] fs/ubifs/orphan.c: remove invalid reference to list
 iterator variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 18:58:46 +0300
In-Reply-To: <1341818834-2101-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341818834-2101-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-s0KIsc7aJHo7+lU1zOK6"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s0KIsc7aJHo7+lU1zOK6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 09:27 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> If list_for_each_entry, etc complete a traversal of the list, the iterato=
r
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.  Replace a field access from orphan by NULL in t=
wo
> places.

Pushed to linux-ubifs.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-s0KIsc7aJHo7+lU1zOK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBt02AAoJECmIfjd9wqK0x8AP+QGUZ/4APMpNKqkDAB97n81t
/kUaueQslsGHXI2eW7JDxj9CWLMkkVNGQYu5Z+gurpAYmF3L04GnZ15PgjBVfuQJ
v6yS6T5L1pPdRcIjOgrFjFG+gJIbKyV9Ua2zf2DNIMTiOdDY1WWgx0EeT7c31T3C
VxTka/Li6RaKTp2XIj8fp5QBIR464btU36l4hf8v+eeci6TgcuX0/189fOOQVuu/
LBqGb6DKN9NOz1BtcpP3EhgEdsOh1w3EC7MpOzZbA+/wECz94Pv/WpTaUSju1OJY
asSEvYoZEeEZdON8jyPjw89bCzzE+WXhXKfh0CV6m2SjBX39p3WQ1PnbOB0M0Hv1
dXK/FnL+noI8Sjjo+fMnF4w6WefpBjVPVo1Meb04yJO6GyLA4CcLzPYQyfnVYdvO
UhtNEHbNiAaMgddg1nY4upgpug4lhCvvwrLHHikLXzPh4Hi+fHDwIDBImdOJPCrK
KYjRgUiFvpITAD4NTXV/y/Gq9pU8utCmbfBGFyNJ6sKk9EZjQF65iU1e0+jcnck1
QlBxvgO9X6m/Y4XCq3ah95XmxNakPvV4MPlRSzEeuzbMCz4a08sKcePRfHbsCZ7M
+ysg+9bA/vOlw5BV9BjWxnPr1vRE7KpWDYJzr5LIR1tkn1sWNcuAmbWw7Cde4zGe
h8HOQlmbQOQJPzDtd0fD
=dDVt
-----END PGP SIGNATURE-----

--=-s0KIsc7aJHo7+lU1zOK6--

