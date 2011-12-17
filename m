Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1LQEdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:33:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1LQEdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:33:07 -0500
Message-ID: <1324096381.2825.315.camel@deadeye>
Subject: Re: [PATCH linux-firmware 0/4] Complete source for GPL'd firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:33:01 +0000
In-Reply-To: <1324096119.2825.310.camel@deadeye>
References: <1324096119.2825.310.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XuEh98rIl0LmMdtCP3Ra"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XuEh98rIl0LmMdtCP3Ra
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-12-17 at 04:28 +0000, Ben Hutchings wrote:
> Some of the source code for firmware licenced under the GPL is not
> included in the linux-firmware repository or has incomplete or
> inaccurate build instructions.  This series adds the missing pieces.
> With the appropriate tools installed, these makefiles produce identical
> binaries to those already in the repository.

For the avoidance of doubt, I'm about to push these changes to
linux-firmware.git myself.

Ben.

> Ben.
>=20
> Ben Hutchings (4):
>   dsp56k: Add makefile for building from source
>   dvb-ttpci: Add source code and makefile
>   keyspan_pda: Fix parse error with as31 version 2.3.1
>   keyspan_pda: Add makefile for building from source
>=20
>  WHENCE                     |   10 +++-
>  av7110/Boot.S              |  109 ++++++++++++++++++++++++++++++++++++++=
++++++
>  av7110/Makefile            |   11 ++++
>  dsp56k/Makefile            |    6 ++
>  dsp56k/concat-bootstrap.pl |   33 +++++++++++++
>  keyspan_pda/Makefile       |   12 +++++
>  keyspan_pda/keyspan_pda.S  |    7 ++-
>  7 files changed, 185 insertions(+), 3 deletions(-)
>  create mode 100644 av7110/Boot.S
>  create mode 100644 av7110/Makefile
>  create mode 100644 dsp56k/Makefile
>  create mode 100644 dsp56k/concat-bootstrap.pl
>  create mode 100644 keyspan_pda/Makefile
>=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-XuEh98rIl0LmMdtCP3Ra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwbfee/yOyVhhEJAQoRkA//Rcru6iQPpiKEBAUqtowPiNyO2EQamUUC
KYs65Rm0R8fyjiAh0JEzKYiHBWoE4BKj/jDFhNf3NLAKtpg6ZvuqeE0wtMPJQuUi
PxncoNkNgi+plN2+cI4Gys1SfltXDsberKgqjuLwmj/0nyIvhSr+AB3fmV+ybXC+
QX81g9m3OfUfKTtaNMaREL/bf0eG3SHbmHM0RN1EiNH5xBv7TvJHUFpX2ODMCuIs
PQFz7P6vvmzjjCMz0uyWK1oEj9GYYAsRJEeFpaXBgNICAhCYWTe1ZtkJEdgCfJbV
PxM9ixKwQcqZyhhJw+25Wyp9QNeRo5jQNE6TqFxVsdzaohaFEE7kwcZ0MO+DfUtM
4QYqHBirDyoWqSeCdgiT0ZEbnyPTUqyIYqBp9UFpYddNc5U9a1T3+wIyoNex6L9U
kDWI6Yjm6WelxbboNuyOJKot/DUux0MU4SKWUdPeGu6HqY+q0yOgylPU11J6gYUe
rbigLXNJ5zOw8wVHjYkgzFmWmdthFgY6MJ1pduSAlkptg2meVBO+qBeDhHsyOJn0
ZO0B/3fQlodlkWElyRYL9PSlSUpl5z1aXKnIo/sJKwetKVRlH4LlyQgNazeSwPcx
3qSTF7D4GJSI20+zZNf2URJhLRJ2T3nZ1DXF6fpJ19a9uZFXrnFY6MsoHtrVFHX6
kVZLJZAdTUM=
=THTQ
-----END PGP SIGNATURE-----

--=-XuEh98rIl0LmMdtCP3Ra--
