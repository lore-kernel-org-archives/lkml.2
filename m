Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2KKWtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:49:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33333 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab2KKWti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:49:38 -0500
Message-ID: <1352674168.16264.59.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] USB: mos7840: remove unused variable
From: Ben Hutchings <ben@decadent.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Date: Sun, 11 Nov 2012 22:49:28 +0000
In-Reply-To: <CAMgPeKUTpA+qn3TA+4xpRa4z_Y1E+6mk+_Xdom+ugdqCttL3aQ@mail.gmail.com>
References: <CAMgPeKUTpA+qn3TA+4xpRa4z_Y1E+6mk+_Xdom+ugdqCttL3aQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Hw9MSKcoESPiJmfNjHE8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hw9MSKcoESPiJmfNjHE8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-08 at 18:28 +0100, Johan Hovold wrote:
> Fix warning about unused variable introduced by commit e681b66f2e19fa
> ("USB: mos7840: remove invalid disconnect handling") upstream.
>=20
> A subsequent fix which removed the disconnect function got rid of the
> warning but that one was only backported to v3.6.
>=20
> Reported-by: Jiri Slaby <jslaby@suse.cz>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>=20
> This patch against v3.4 also applies to v3.0 (and v3.2).
[...]

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

--=-Hw9MSKcoESPiJmfNjHE8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKAreOe/yOyVhhEJAQoo4BAApxWLGd3EBlnhfftX2AojRVvvzYwjDXO3
N3T4uhQD5cNYiokoDvG2yybqQPEGkwGFtpiqra2JS0kB823AoqUFPkUMZWsByuq9
B5K0zVXvQJG+OydZweWr3qtiMsacgY4uxkFI7mjgLctthHCJjYVn1eAAHz8y7MTd
vxi0m+9/pHyVXLDrfERcS/7FjsHetwEVlREN8i9rQ2Qugo90J3XY6FFRHZj7fcQX
jSLyfsxO+Ak9JfSh9LN6Yason/HJWhhaObQmiwrrOYwsa0q7d83j1MN/v7BON/Xv
80zJeLwEIHgGMS0LV/jRS+Qb4SlYsbVa9mp9XX6Bdr1ecFXXgPYEXCQaNEe/dzSL
uZmSD8MjC73huWYQzN9GA8T4Jz9pL3axNh7XEX0+SRvJMLP0T8hMrNn7cv/IFs4Q
vvqauyTgnxDjeijanvvnklBVnAF73+QuVPV4cR88Jh2gus3hfkWJyW+dOE16jbHj
TlkxOTVaVCgoVE17cYjBnLNC/3K5cgLkY7zGwydVqEbvqITEcD6wmdG04IP5fqMa
as7LBGj3IoJXdzwjZaeoLyorUSHyM9pczkLAarwgrw+0ka3CsMSoURubR2PAi1Nr
k3V9g6uE1eOWiu4WWniKGpIrtwLxtrR+tRZQGBWogzZ6NrTaNjMvjiL5OXOKRf44
zwOLfj+COw0=
=ZX7K
-----END PGP SIGNATURE-----

--=-Hw9MSKcoESPiJmfNjHE8--
