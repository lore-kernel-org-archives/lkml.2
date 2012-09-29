Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2I2M0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 08:26:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36427 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121Ab2I2M0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 08:26:12 -0400
Message-ID: <1348921550.18878.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 045/262] ARM: 7501/1: decompressor: reset ttbcr for VMSA
 ARMv7 cores
From: Ben Hutchings <ben@decadent.org.uk>
To: Will Deacon <will.deacon@arm.com>, Matthew Leach <matthew.leach@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 29 Sep 2012 14:25:50 +0200
In-Reply-To: <20120928183003.275952918@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
	 <20120928183003.275952918@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+CKOwOMenKE3O1ZsAYIc"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+CKOwOMenKE3O1ZsAYIc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 11:49 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Will Deacon <will.deacon@arm.com>
>=20
> commit dbece45894d3ab1baac15a96dc4e1e8e23f64a93 upstream.
>=20
> When enabling the MMU for ARMv7 CPUs, the decompressor does not touch
> the ttbcr register, assuming that it will be zeroed (N =3D=3D 0, EAE =3D=
=3D 0).
> Given that only EAE is defined as 0 for non-secure copies of the
> register (and a bootloader such as kexec may leave it set to 1 anyway),
> we should ensure that we reset the register ourselves before turning on
> the MMU.
>=20
> This patch zeroes TTBCR.EAE and TTBCR.N prior to enabling the MMU for
> ARMv7 cores in the decompressor, configuring us exclusively for 32-bit
> translation tables via TTBR0.
>=20
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Matthew Leach <matthew.leach@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

Is this also needed for earlier kernel versions?  If so, can you provide
a backported version?

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-+CKOwOMenKE3O1ZsAYIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGbozue/yOyVhhEJAQr9rxAAj4+A53Rp9E+DlMe9Pu/xNmJWTUXWRLx3
xUVyrUsNyzk8U9OYxBsZ/mjP1WzwOzNUFDyG5BjvmCh5L30w4knrZK8p1ehrvXpr
ekihw2VNFwXjCmE1T/gFnosXNClAFjoi14j/PIoSd2u7NQJWiWpxYz45uBGclqmh
TxHJSEUVBIalThcPiKtktxgk35BtVURr5hqg/ZCafxcbakGwQUQ1aV47yrd300lh
L95KqaTp8eaMX+f5s7XJcWfsMAamgY1jLxX+gfxajooecleypBnZ57OmsVLU6Tz3
el7DYNfL+suTbyVl06orOdNJ8JejxBN5BMlOAF1IFo0Uo7LpwntIG5NU4yMy7ckL
RabGQGxEWGS7HMRLmYC6s3I9cCgKsdouW5/IspOEfhoWREKUygP9iNSVl+t525Ej
l73Kmo+bYDEE88JOAQY0EPMldFiOxRJV/vLELcs/bC0EOEvlAa/nP7s36b2X7mND
/X7BKLkmZwdXZ938OEmjgHvpw5SdXXkC/2Ax2u8soiXkCbHPgsEfIA8f4jVX2NY+
V4pqaWi9OjhNABGGlSpSoWItTG8QPtOKIw6RgJEIb/U2f943MBXaJX3QtpxLRj2t
1iRUo9nLv8xwFCYYmlTdA/YNjyzSh1EDROG8cVD2jRsOgjCcX8y5UL/ZtoG/9Pzn
JNIeC8yc5ng=
=wu/2
-----END PGP SIGNATURE-----

--=-+CKOwOMenKE3O1ZsAYIc--
