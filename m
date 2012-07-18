Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2GRKq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:46:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56080 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2GRKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:46:27 -0400
Message-ID: <1342608053.7530.11.camel@brekeke>
Subject: Re: [PATCH 1/5] ubi: introduce ubi->bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 13:40:53 +0300
In-Reply-To: <1341389164-24409-2-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-2-git-send-email-shmulik.ladkani@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TOSrJujwFlCm3CHIuXcR"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TOSrJujwFlCm3CHIuXcR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-04 at 11:06 +0300, Shmulik Ladkani wrote:
> Introduce 'ubi->bad_peb_limit', which specifies an upper limit of PEBs
> ubi expects to go bad.
> Currently, it is initialized to a fixed percentage of total PEBs in the
> ubi device (configurable via CONFIG_MTD_UBI_BEB_LIMIT).
>=20
> The 'bad_peb_limit' is intended to be used for calculating the amount of
> PEBs ubi needs to reserve for bad eraseblock handling.
>=20
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---
>  arch/arm/configs/sam9_l9260_defconfig |    1 +

I've also amended the Kconfig text a tiny bit and dropped the defconfig
changes - let's have them separately as a single patch at the end of the
series.

--=20
Best Regards,
Artem Bityutskiy

--=-TOSrJujwFlCm3CHIuXcR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBpK1AAoJECmIfjd9wqK0K2sP/3YP432g7PTQLuoJptLICRtj
ZXJEFqp6CwNSeCoSpjOnUhETGGuU1sUlMsmld1IhTLCEE7wu9zt41gTtdZ+6vvgX
lPY2E3Vfw5dMHEkle/iEW7dpWGFIxmoR4r1CUZpZiLzBmuOMy4ZfQhcKz5bmKKnb
1g0Ii0x6Tfs2o1D1fWM7ULCxnG/+deTDC7cceHgDfXV4OkRRdVN/+gdPADdGsQjF
6EkyoKRWKCD38ciTUPiK1gOeIXiq4B0JEAmlTVmKy/4KhgeacgvR0WHZO1WjycgH
KDBuKq80sAhS+AeBhhk8VUUZStT8L8ABwitLA8aU0hzU7KzN8G+nBCUYtfaJxcCV
b0mYWBZurCw/NQigzkOxFzVd/+A3yuEEt8dxf/MJe5gJ0X4RkFG1QhIi+bLRTKEc
jwKQPuMJrKiwMVHEUzJ4OD2WX2G/00HKSi/V39jREeZcqX8c7hDeaRPXBq/VQIdq
wo9yl6FD1osDHRHhxJeIni0Vsa7h9FJH0DA2tjzviATVqwlf/dYaPPHDNKilRUqd
ECtywwXcJ3zubddGZFGB+oXHzht0suAXGR4/N4HsHQ1fYaRFGgQ/gF6Bc4BIt3pz
O4eSx1IePYOMTLmpFBw6M6aNQMvXLmLVW5TbXw0yyzW08TThewvD73eiPTA2dF5n
5ZOaTAkBumVKxaXRng7Q
=6JqX
-----END PGP SIGNATURE-----

--=-TOSrJujwFlCm3CHIuXcR--

