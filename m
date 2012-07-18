Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2GRGzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:55:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61444 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GRGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:55:38 -0400
Message-ID: <1342594206.31927.7.camel@brekeke>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 09:50:06 +0300
In-Reply-To: <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EPpaMrZmTaruFoRElDs/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EPpaMrZmTaruFoRElDs/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
>=20
> The Kconfig option is in per1024 blocks, thus it can have a default
> value of 20 which is *very* common for NAND devices.=20

Why do you prefer per1024? I'd make it centi-percent instead, wouldn't
that be more human-friendly. It is just %*100. If I am a user, it is
easy for me to calculate % and multiply that by 100. This per1024 thing
would make me scratch my head...

--=20
Best Regards,
Artem Bityutskiy

--=-EPpaMrZmTaruFoRElDs/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBlyeAAoJECmIfjd9wqK0SvoP/3NpxZvF6XRyRrYHiBRDj6pJ
eIHIPvXdXvLKPYVcAUq0lmMJWe9oXTpjbhUxBB1D5ZGVpCsn4ZuGpDWhFlWyZ/21
RalW3AVP0sQUZngxcmQvFJQs+j5CWErlY67NUzsLmsJVfAisN9ZQ/kLUyTNpqzT0
iG8iLTZiprcONvRkd4vA4VNJtE47fT5rp4HaqjYFrJLijFCGldeLUvrABuUHcqSL
F1FGmVizADOd9XBeoybwe52F20J4h8qxp0M2bUu1+rpCsIgtFde00zT8e0XbWodJ
ClzRBgN9sDJkMxmuasJYrmRSiK3WBJyD1BhzH4inmhoKyZYf2Oefw+56m8UMpDir
EX+FLkJZrfL4NbooY+55BkX3AOQMTRA3rwH3ormsrxVfVZmHZivJZdNAiSWx9SVX
sKK8eBSlyeal+0ntO6JNzxhgOpU1skr8PH26a9bHLp3UBKfqPQlKQw2whasgkhNX
SB/40Z2UDqNZPySku8L3KBvQqVuG/znw9Io/nRD4wpOLbIwxFFaTLeN6PyAB0b75
fvHqPhOdXjPmJ8MEdXVel6Ep4wqzS+OrA52URpnP0KZMWt5nW/2OYP3kWvLNxr53
RI4A5TowBQI5CdhyqR/tcVA7bvOt8qT2AjF0ihv126EMwjZrBOKq4Q8yFl/w5hid
ko9TNlEetKuI4qLYLDBb
=4RZe
-----END PGP SIGNATURE-----

--=-EPpaMrZmTaruFoRElDs/--

