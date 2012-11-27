Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2K0UZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:25:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60457 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320Ab2K0UZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:25:51 -0500
Date: Tue, 27 Nov 2012 20:25:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: as3711: Fix valid min_uV/max_UV checking
 in as3711_bound_check
Message-ID: <20121127202549.GG32691@opensource.wolfsonmicro.com>
References: <1353689452.3260.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <1353689452.3260.4.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2012 at 12:50:52AM +0800, Axel Lin wrote:
> Below cases are supposed to be valid:
>=20
> min_uV =3D=3D max_uV =3D=3D info->max_uV
> min_uV =3D=3D max_uV =3D=3D rdev->desc->min_uV

Applied both, thanks.

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtSG9AAoJELSic+t+oim94WAP/j072SfDBBaGNKe6OiI13NZN
UkAEGSfYO2xxZVXZOBBFZRP70wcnPkVygPmi+6fa97xrvj/gRYJoXxPZVoS1t6Y0
pzNjkFepbRDA5fYGRP62O1oBiTe4no1hBHHawg6YOnFYXCjlLWynj6ppLUeCjiRf
h1tFkOrlJOZ+Lk/IiTDX68kwEA3pfRLU7/Ap6B0iybBXqMm+tbpgM/369jRbjciT
A5Rccqg0l2ULgCjOTa20P3ERYx14DIredJ2322cXJ5DGSLlM/rNSc/5mJTVtoCTg
LJvj26BeLu3Nz0cAHBepA3X9Tq+Au1L2oY9UAat569v/sPWXqoiR6lHY0ms3K/yb
rQ7K4mIB/o8Kd76N/oEZj7MNtELSORRvK4jg8LCfGTy23IXL5yIXenuzkMjJMY1U
SBojbu/uYrpe6HBS1gEKu8koOck9Yz3Hfz6GyN8DpzxAQyc+VKY8EQ1pK2G1QhgF
aLT2uzrnGPzxTOxDo1xWAOYF+0DvXBHFwxMH3G3GUxf18x/qyckFXF6YVBedjis0
LItxz2fiay5oaUGPhCQr3VghOlXhr9ZeQTbcyzNtKEDROfyPhzP8vjqjnqtp0TAH
0PhQPvi7kwUsFQU9P+8bVS1VYxG1tmSQ+dwmxwbWLCEuBaHDjvLnoPabY9SI8Kkl
32P0/Kp0eynU3VbmCZ3+
=/FqJ
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
