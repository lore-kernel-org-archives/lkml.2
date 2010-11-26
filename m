Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0KZXMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 18:12:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49793 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab0KZXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 18:12:33 -0500
From: Ben Hutchings <benh@debian.org>
To: Francois Romieu <romieu@fr.zoreil.com>, Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, 564628@bugs.debian.org
In-Reply-To: <20101126224914.GA12266@electric-eye.fr.zoreil.com>
References: <1290772470-23713-1-git-send-email-hayeswang@realtek.com>
	 <1290779458.3051.45.camel@localhost>
	 <20101126224914.GA12266@electric-eye.fr.zoreil.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0N5UtheoqsfLlaIwWQbw"
Organization: Debian Project
Date: Fri, 26 Nov 2010 23:12:26 +0000
Message-ID: <1290813146.3051.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: benh@debian.org
Subject: Re: [PATCH] net/r8169: Correct the ram code for RTL8111D(L)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0N5UtheoqsfLlaIwWQbw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-26 at 23:49 +0100, Francois Romieu wrote:
> Ben Hutchings <benh@debian.org> :
> > On Fri, 2010-11-26 at 19:54 +0800, Hayes Wang wrote:
> > > Correct the binary code (Low pass filter & DLY_CAP fine tune from uC)=
.
> > > The incorrect ram code would make the nic working abnormally.
> > [...]
> >=20
> > I'm glad you finally acknowledge that this is code rather than simple
> > register initialisation.
>=20
> I am not sure that Hayes is a native english speaker.
>=20
> I am glad to see him posting here.

Right.

Hayes, by 'you' I meant Realtek, not you personally.  If my reply seemed
aggressive, I apologise.

> [...]
> > Below are the changes Debian currently applies in preparation for prope=
r
> > licencing of the firmware.
>=20
> Do you have some scripts to convert the data at hand ?
[...]

No, it's easy enough to convert a single array by copying it into a C
file that dumps it to stdout (assuming the file's byte order is defined
to match your own machine).

It might be worth adding some sort of header with a version and
checksum.  Your choice, really.

Ben.

--=20
Ben Hutchings, Debian Developer and kernel team member


--=-0N5UtheoqsfLlaIwWQbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATPA+0Oe/yOyVhhEJAQLNwRAAgOm8Uoz8rBF9u3PhENbpG8YtowPLm5dH
FGRHbq813V0/mmdbwXSE60OZf/LWuXTuab7GtLKPuqxH6j0tcjVE/bIczs47zxEO
qrCZoxAvOTbD0i8clPgpbrpjhoVaEWCYcGdKPQieiNvdnhvLoZcM/OQOr4DyRiYU
kN8O2LBw47NbQrpzqX1FFWQJXpk/Sb/IyHw3KjNXGv3loqT5cifXzroviQfXDHA1
R/ehFejAdhdBbpSiuDA0pzoTVSjjYQQVIdGg2PnwDypNxf0yhVXkw/o4dVy+T6YE
Y5Qpep48OxLJEfdN9IEDYSWb8SiUEX/rz6P0Nf8HdiNdyIw8yPHXtuLw6rA3Sd2k
MPS2zz/wregYa6PUXxTEQPLJ/GEq7TqG1VAxap49PdwmNY+wZ0wmqkQrgmylTi7N
ppR2KllB6CMzx4l1l9s5qsnVKaDKqFqZ4/bgZaiA93034nOg2whYVy/fpJwe1zWC
RHiaq985kqWSxVbXbXyJV1djuptEi5hJBzbe0YX5zGgtpWYpp0sNXe3xYOmV6DAR
8e3Jso6f0CRaKRmuDPL8i8NubLacijT2/ii55dwgca+S/9TwjgqBSm+/VUSNRU+5
pgckoA6R2mLTuzddAK64twGQZz3ss3V/Hj/vXqNkL76JqwhRLO0ftFzMjbWqPZGJ
X59z3NqN4mE=
=wgUx
-----END PGP SIGNATURE-----

--=-0N5UtheoqsfLlaIwWQbw--
