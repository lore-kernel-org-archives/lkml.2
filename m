Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2GJAUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:20:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42471 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab2GJAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:20:23 -0400
Message-ID: <1341879612.25597.310.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 35/48] dummy: fix rcu_sched self-detected stalls
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: herton.krzesinski@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        edumazet@google.com
Date: Tue, 10 Jul 2012 01:20:12 +0100
In-Reply-To: <20120709.164923.898772652506167140.davem@davemloft.net>
References: <20120709143121.743971024@decadent.org.uk>
	 <20120709233901.GB3237@herton-Z68MA-D2H-B3>
	 <1341877626.25597.300.camel@deadeye.wl.decadent.org.uk>
	 <20120709.164923.898772652506167140.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R/p1qmh1hIS6LXr5Vsw0"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R/p1qmh1hIS6LXr5Vsw0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 16:49 -0700, David Miller wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Tue, 10 Jul 2012 00:47:06 +0100
>=20
> > I built on x86_64...
>=20
> As did I :-)
>=20
> > But it's not an important bug in mainline (yet) so perhaps we can treat
> > it as only required in stable.
>=20
> I think this is the best thing to do for now.

OK, done.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-R/p1qmh1hIS6LXr5Vsw0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/t1Pee/yOyVhhEJAQobyBAA1ZLPXm1UvwRdqf1fYIFzN3PAlzADO2mn
GWfy+4IgCc6cTEmV0VSQbz6yoxoocDm50hblOz4nGES2t5EvEBl34Ua+IzQhsLr6
dDT1Z2wz8a0KWzhVLnKFmAo8H8dudywL9huKb5hUAj8g3WX4S43t9hltDR6YsWHg
gD/Wmfblce4pAeYyPuFB+r0+ogjPd9F100ot6sc5d8isXGEiCBzo4HCxjc2qeDQk
rQAEopvNwmS2Mfz6pKmFefiwPZjI6u90uQPKpro+oZv5Uj56c0bf7yrRO3DMBBo8
5Lbbm+4RKfmE4p+B06DVunU1eGFN6CzLA1w0whv8ZVTQlZfjQGyjj9esMoZW2tcS
fbTrpV8ncvZZlyrQfL3F6XDZN+Hhoezf+7Vkku5j1rhTkjJiHV1nPOYI1yEE+JU5
3F4IRVRWEFASrHROFxkiVlNR8fJUG2AiO2ykzRAKsSELkjmagxXnyD8ziG+gXNIx
eZlzXz1M4oP83nMFF0QxpIPO3N/aSsONuAJGT6LoaYyn/x9DLXVk1gEvinUd1UhA
2Mw3lmA2dtjrWFB78GLbVh+ULaqrSPs6WNoeNDtIGahq35WI1WggOS4g011gJPwj
PEyhZgQEaq3EfafN7q/D7ANTpqi/M0q6JL0ApTUfOnVE5r+F99WpZTLDNPnq9V2C
7Xnd4esQ+wQ=
=06Jk
-----END PGP SIGNATURE-----

--=-R/p1qmh1hIS6LXr5Vsw0--
