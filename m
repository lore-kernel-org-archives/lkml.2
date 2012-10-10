Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2JJCYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:24:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59356 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab2JJCYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:24:17 -0400
Message-ID: <1349835846.6336.24.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 028/108] ARM: imx: armadillo5x0: Fix illegal register access
From: Ben Hutchings <ben@decadent.org.uk>
To: Estevam Fabio-R49496 <r49496@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>
Date: Wed, 10 Oct 2012 03:24:06 +0100
In-Reply-To: <86D15885F63D1143A519F161FB828EAF165AA3@039-SN2MPN1-011.039d.mgd.msft.net>
References: <20121007225834.673681075@decadent.org.uk>
	,<20121007225838.581640179@decadent.org.uk>
	 <86D15885F63D1143A519F161FB828EAF165AA3@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EZYyhMYCXmy5nfXNPosc"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EZYyhMYCXmy5nfXNPosc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-10-07 at 23:37 +0000, Estevam Fabio-R49496 wrote:
> No, please drop it from 3.2-stable.
>=20
> This one should only go to 3.5/3.6 stable trees.
>=20
> Otherwise it will break 3.2-stable.

Thanks, I've dropped this.

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-EZYyhMYCXmy5nfXNPosc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHTcRue/yOyVhhEJAQpbrQ/6Akqm8aSuHvyGZYa8pq5nRPu9cn9yrn6X
qoCCpLF0TA4sjNPkpPd+UjUpBdrjUJto+s8fWsCqeO1Sm0HBXiielEIfUH88HYLi
zke8KCgjDgxnlMT+9fvOe5P42OAFIE9EVoq0i2LOXBQxSxWTi37ReAZD92913n4u
rrbN8MjkWniWIicIwYR+qJ/33MS7/fbGQF0QQ4NSu3OEOzEjWDP76ObPWsM9rt6z
EtTHLmC4ukUdRXMVwcfn15XR4TfW6k7CB8zZxF8QH2LN6Bs4wXuAg5lfBD9Km1lR
VEDhY47ezifNFG1Y2IWdqDKXVVMt6YqnBPb56DCYlzpLk6HiwPKv1pG5kJPWFo4j
Favzg7e39CPFiPVt+YjB8bEYVG4kVzhkgeyl2pvrD4LDfDXjTVI2Jry1pUBIqQ4p
+GYLYXGcmwGY6FeYzOmcK5+UW0BBnrjP5dowVGBAykYnXV/r+57/ugbbj2mXA7pm
qhe7aLawkIh5wDjKOeXEjRzeCtSZQIO7o0VzULsao/VFBKFu6FIXWSRBVohvN8lH
wBGm6AvhDrR5pZQ67BV0FQSYBEM4Qgj3KovJtWBn/JJc5htJbWUyUBa8buZOkAZm
fvKkjapMnQpv089MD4WKMc4JDTw3NIEcilqbB6uD7lsCa+SxvmHO++rP8Y66fM0u
GDws6c2+oqQ=
=qt1d
-----END PGP SIGNATURE-----

--=-EZYyhMYCXmy5nfXNPosc--
