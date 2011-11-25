Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1KYUCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:02:38 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56431 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1KYUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:02:38 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/8] firmware: Sigma: Skip header during CRC generation
Date: Fri, 25 Nov 2011 15:00:50 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <201111241222.00189.vapier@gentoo.org> <4ECF580E.3060301@metafoo.de>
In-Reply-To: <4ECF580E.3060301@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2078504.A4lL4cGeq6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111251500.52711.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2078504.A4lL4cGeq6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 25 November 2011 03:55:42 Lars-Peter Clausen wrote:
> On 11/24/2011 06:21 PM, Mike Frysinger wrote:
> > On Thursday 24 November 2011 07:48:21 Lars-Peter Clausen wrote:
> >> The firmware header is not part of the CRC, so skip it. Otherwise the
> >> firmware will be rejected due to non-matching CRCs.
> >=20
> > that's because you didn't compare to the right value ;).  include the C=
RC
> > -> compare to 0.  omit the CRC -> compare to the CRC value.
>=20
> Does this really work if the CRC is inserted somewhere in the middle of t=
he
> bytestream?

i don't think the position matters to the CRC algorithm used by sigmadsp. =
=20
math principle: a ^ b ^ c is the same thing as b ^ a ^ c and c ^ b ^ a.

i could be wrong as to the CRC algo used though.  simple enough for you to=
=20
check -- i implemented this firmware code based on a spec i wrote up for th=
e=20
sigmadsp peeps; i never actually had real firmware to test with.
=2Dmike

--nextPart2078504.A4lL4cGeq6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOz/P0AAoJEEFjO5/oN/WB+/4P/j1YO+hvBWmgb6hjuwEGuoUy
tFAJVS61ACH/gaDqQtQmi94IoeDv1Lb6EUkgGHz5meFTUnVeiBaC+8ILQS+gvVRD
YuCTTEJDn/b1RC4jIp4zJA9PP4sulAGUjkFQaIa7h/J8oMEVlUJ43b1MWVF7mGlU
9eM/KEjsLaWOzUyqdOoDOU9HfmJgZUm+yH46g6A7RM/XKEiNvVl9QzH/vaEZEH8I
opxjqYTQI1EJRGZQPbtPrzJ1DwE91nvQO2QZSyxDveL/qUkbGXV93A51GOLa60j6
e1EybV4e27zvEywLFw8ZUuYf2Vq7tnZeYq27zqy7yNc4SlCn1Nl39qGIsme3Q3R2
UsdUS8SYq0FZDBGWfiSgaiGXDzyEyaPOJcdLd12kXo4VthfDNWDSc9or1D31jY05
RbqZAYkqAhRUyK/14Yf1uAtoo6u3l1rstUHNNactOckNk8ODDIS6nzZSUR29S54Z
bCJHegLvCUi1VWEaSEWoKWDqoZQ2I7R14aFV3RFEx3I6LbU65nm2fA5f64kYfZql
q7ql5aMKZNc5CRQdy6MAlyagifghWLBEti1NLVSxzjcwnEdZNzsbBElh2OVA5gOK
pfiKH3G8zlyVuqY9Cjsz+s+IiuX9c3vzWVwzzOw+3RUfMXmg+vpSO90qtTz2bfYZ
MMQNPC4wtl0inD42jG6p
=gINA
-----END PGP SIGNATURE-----

--nextPart2078504.A4lL4cGeq6--
