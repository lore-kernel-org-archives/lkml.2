Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0LaOlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:41:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56547 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab0LaOlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:41:24 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <m339pe6nmp.fsf@intrepid.localdomain>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	 <sV7shrPOroO.A.CqE.K-7GNB@chimera> <m3zkrnv1x9.fsf@intrepid.localdomain>
	 <201012301545.15667.rjw@sisk.pl>  <m339pe6nmp.fsf@intrepid.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3WouH82J6WMWfUvMN0bF"
Date: Fri, 31 Dec 2010 14:40:47 +0000
Message-ID: <1293806447.2870.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Bug #25442] ixp4xx defines FREQ macro; conflicts with
 gspca/ov519 driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3WouH82J6WMWfUvMN0bF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-31 at 15:08 +0100, Krzysztof Halasa wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>=20
> >> This FREQ has been there for years. Not that it makes it smart, and
> >> I'll obviously send Ben's patch upstream for 2.6.38. Still processing
> >> incoming mail queue :-(
> >
> > Well, the patch is in the mainline, which is why it's still listed.
>=20
> s/is/isn't/ I assume.
>=20
> I was referring to the "regression" thing only, i.e. there is no any
> regression here, AFAIK at least.

There is a regression for the ov519 driver on ixp4xx.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-3WouH82J6WMWfUvMN0bF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATR3rbee/yOyVhhEJAQI4cQ//Wip3xNzlQpAPI+H1H8dAoMXNn7vXWrfw
/nc4JmIHlxr0yZxpeqivCRO35Pxu/XMrxe4d758LWWYiSWsjHo4uh17lmI+O3/H9
lVbwsb/M+wHlBufBwQBG5OXFAfbTWV2IzYYc3QiZy2px0dkGAFoxw2VviK/ICAAk
oIUB7dYZDm9KrIg9DCT+kWjvAiRVAi0tM0piIXnvvmwofqtQoTb0VYMu96hff/ue
StBNay0ZEPCXlLZcdMcFMdatyvR8ji2Iauwr5DOT+uGl4kEvYDl2FHz7hjEaoNIp
F7bFia2IGGp05uIUZ0Hv7w2omNg7txuvooXVtUa2G9dqWTcjXCU6rwAfiGxWPMzH
jUZihed6rp1gfIi6ML3FkKgBFKUTd2isX/tTA7VEFYRH70+/TkjWFzQDYvjcxGQJ
fx/8r6lbHHEIl8MrRrSRDKEZG+KMMgSLKYmkHBudnEY7YVb0f3uQO7Vc1c7AHoRy
A7l5AeRtgl0dgwDO0hknSsvBMuMqqtrWupaYt/9EfGhltYWANsudyXMU7krYVJWo
scuPpGrqTVaEBwEoZx9R/4KYtQrKuIjf4BvNlpqvTarXhguO9ujn3yxKZM4l6aAd
FaV3Pk7451dm2YF13e/i1Eh+Urppn4nPohZgO8K5Uo0FvcTHBZK1JRsIEXE2XSzx
qbukk+DDYs0=
=OqBa
-----END PGP SIGNATURE-----

--=-3WouH82J6WMWfUvMN0bF--
