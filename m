Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497Ab2CFMOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:14:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52380 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030437Ab2CFMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:14:32 -0500
Date: Tue, 6 Mar 2012 12:14:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: Remove bq24022 regulator driver
Message-ID: <20120306121429.GL19635@opensource.wolfsonmicro.com>
References: <201203021355.21669.heiko@sntech.de>
 <201203021357.44770.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Content-Disposition: inline
In-Reply-To: <201203021357.44770.heiko@sntech.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 02, 2012 at 01:57:44PM +0100, Heiko St=FCbner wrote:
> The bq24022 driver is just a specialised form of a gpio-regulator.
>=20
> As all former users of it now use the gpio-regulator directly, there
> is no need to keep it around.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVf+fAAoJEBus8iNuMP3duQMP/2al7hfiFseNoHlV5eAnB3v/
m++vmRan9RIrRODE2cDc3f8tbgZR/m0uG6PqfHtg9cYZAlHkwEXxPvOR8RtVYTqQ
Y37EhCgHtzXw/z08vIKlRydro4tDFFHt/cxLagUuxfTt008iXHe5AKn3xgEO5FhK
Niz3MaKMvDPQGGH1H0KkTULZr40HbOE27bJ4R5UvrESuAgGe/XYpmvtiytCvM2Gf
I/nTOu2P6/biPVHzc8MdFLbdqHa1MRJ3Jw8Bnxl577G5BaYqS9rvTGdOnUyAoKl8
laXI+FiRl/MyiVTHUkfB85x4yfH7kQO6Ugw1ODwOFGekaDFJJYxtFUGQOQUl9il8
dtrGSlNrrq8deh21p/43IjwhZnlzrFAozHPFWa/xJv5ajxTPW0UNb6rZrXjyV7i0
p05AbRRwEjBeNjHmCf/fMCupQa8QjR7C+LReLfoBZyWdNOrwIVrJ6CNwKjySIwj3
IhXRhTLMq4YT35I3hFMcsdVPw8SOphgsI2itGqrNaeW18tGq2RXzb5sxma+UhNQr
uFsw9O3HLcPCSrhXPdZqLQLs2Bd+QPWwjIgRyBZUJPBZ07SyQVS/vtM9b3BQ9Ly9
n0FRiQ9unQ/uH9K7ZS+DdScO3y02E5+2/d1yuczC4ZelcfgczGPsYhZyU3287ghf
0qX68clEiLjTv8iipsIV
=3Fds
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--
