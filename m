Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2FOCLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 22:11:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53266 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab2FOCLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 22:11:24 -0400
Message-ID: <1339726274.4942.76.camel@deadeye.wl.decadent.org.uk>
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 03:11:14 +0100
In-Reply-To: <4FDA7D20.1090004@chelsio.com>
References: <4FDA7D20.1090004@chelsio.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EsdnOAyg4jrAGuffoVf4"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EsdnOAyg4jrAGuffoVf4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-14 at 17:09 -0700, Divy Le Ray wrote:
> Hi,
>=20
> Can you please pull from the following URL?
>      git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
>=20
> Commit 54f64ed387a5561d4c9fe698d57343b108481cf5 update the firmware for=
=20
> cxgb4.
>=20
> The following changes since commit 4c79292308ead42fc786c8e189921196ccc298=
ff:
>=20
>    build: Implement minimal GNOME Build API (2012-05-25 20:41:26 +0100)
>=20
> are available in the git repository at:
>    git://git.chelsio.net/pub/git/linux-firmware.git ..BRANCH.NOT.VERIFIED=
..

Pulled, thanks.

Ben.

> Divy Le Ray (1):
>        cxgb4: update firmware to revision 1.4.23.0
>=20
>   WHENCE                  |    2 +-
>   cxgb4/t4fw-1.4.16.0.bin |  Bin 298496 -> 0 bytes
>   cxgb4/t4fw-1.4.23.0.bin |  Bin 0 -> 326144 bytes
>   cxgb4/t4fw.bin          |    2 +-
>   4 files changed, 2 insertions(+), 2 deletions(-)
>   delete mode 100644 cxgb4/t4fw-1.4.16.0.bin
>   create mode 100644 cxgb4/t4fw-1.4.23.0.bin
>=20
> Cheers,
> Divy
>=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-EsdnOAyg4jrAGuffoVf4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9qZwue/yOyVhhEJAQqZtg//R67pByaGyfPWL10h0KOk6hilNML3mV8m
gV5gsr0V7rOJQq/KIqup91BRQohJSaxfump7C5DqXHmD7mjisya89icqNYjZY5ZV
RLJZ4xZgeTZf8B5sCmX6f7ZH6AhQqOoI4moZVC/LFh3ocV37q1UXVUJLpHMfr3wi
QYUz2upoe9idlw1puwSUhLMJlkUuyKsye/ycMzix6+u1ZosEdnOmft2eVa1rlB6s
QX13rW8SBVEWSR7wtQhyEHVtuMETdbrFpo6/55TFmfK0/zi9V8YX6skuTT4MtA8A
GM734yvUjT5KxRqGmzaSIs/co/WoAVPY4YsUnyGeh7v1GkqoHkGPW6ioaM81hQ2h
lZZzCa121d8+ij5RGx5eNrtxCpbi6j1HmBhh7rLGvl3GvpyQ0oeGeyqSWEOCbENB
H59Q12CyYicPfRAMXNXdckV7scCnXYxh1wOlFCUNW0ltIB0ESp5buCuxCEamkDDb
YJgDvpBM2T7TnmauPHCK+1qvijfm43zjF0K2cQuo99bQknnl6E/qVWJS7wqRwUc4
Ke3sbGc+6Ync9du3+HQ2pvKowEtpmx70FRNCZ3fgRFWZgzwBBK3aMv6lAbmDV/Gk
OCC8NT77B6TjrsBzTzIZAVw95LhN28Idd+X9BcTvNElFfMDvj9XqfZwALEe2QcZt
HGfOOyqS7MQ=
=Vuem
-----END PGP SIGNATURE-----

--=-EsdnOAyg4jrAGuffoVf4--
