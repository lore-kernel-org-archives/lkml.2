Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2HIDNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:13:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52656 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab2HIDNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:13:38 -0400
Message-ID: <1344482008.13142.206.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 040/122] batman-adv: fix skb->data assignment
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Sven Eckelmann <sven@narfation.org>
Date: Thu, 09 Aug 2012 04:13:28 +0100
In-Reply-To: <20120807221951.826510164@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
	 <20120807221951.826510164@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lxCQdF3YUsTZFzeglEos"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lxCQdF3YUsTZFzeglEos
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-07 at 15:25 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Antonio Quartulli <ordex@autistici.org>
>=20
> commit d2b6cc8e460494251442a877fcbc150faa175b4f upstream.
[...]

This is a duplicate of commit 2c995ff892313009e336ecc8ec3411022f5b1c39
which is already in 3.5.  Please drop it.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-lxCQdF3YUsTZFzeglEos
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCMq2Oe/yOyVhhEJAQpkxRAAtpFQryWHpb45H+AflF89BZge5bLgb8D6
GI8ev926IuTSSW1rHLBfWbtcFNOCHsu2PzvhAlJ1dyd4M52kVwvR4Gys0jOyxoeB
adbM5M5vb0VhwYCB2O0JqeGxZKRhPTPugNbTVNBPkzXB3xaG1wD5xx/7giBeY6ZW
QpJ67VA+xV1jAPJA//QkL87D/ieYdmMrADtIXGTTiFw8mBf7OmplXT5jbizU1NxM
dTJFTe5XGEa4WxUztPVqYO/z4OCblzWcfIM6UUixZwCm4n6i3PkLZdRP9KtF3zQf
lBS75LZzkxqXLtvVWkRX1HlF9+gvQwvuUbsxR4WeTqQDrG6AMM4jhlBZ9e1xZBHV
uQQ+H0L87BRTD4PmIAjYBKp3IK6c59wt6WeW8ebtRA1w75dxbTf6JrPytENUS+XK
LCP/E+cNDAymIvHI9X6Es+p2ONIqSvg6qOGnrw2gntyJ7BZvL0x5tyA/zCaXqJ15
7Mp2ULL4+5g24TLES/Uhu8Yyomsn7FTgt787KB5/e5mrCqx0GDSaniMAx6Kcbi7L
u/kfHFk6pnHd1JIoRRJCY9yhnmErkWsTSY/n2ey1Asz5swa4gO7iZI59nzjC8hM1
BcGVDQHUuGkiAkDVFNEuBGbEXP4kNHrQi/eUExTRXXNUmgHHfrd9UxvA/iQT5p1P
XQziTRoCj2o=
=j7sC
-----END PGP SIGNATURE-----

--=-lxCQdF3YUsTZFzeglEos--
