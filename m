Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2FCM2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:28:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36221 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2FCM2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:28:17 -0400
Date: Sun, 3 Jun 2012 13:28:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, marc@cpdesign.com.au,
        philippe.retornaz@epfl.ch, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regmap: Fix the size calculation for map->format.buf_size
Message-ID: <20120603122813.GA19969@opensource.wolfsonmicro.com>
References: <1338509430-24416-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1338509430-24416-1-git-send-email-festevam@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 09:10:30PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> The word to be transmitted/received via regmap is composed by the followi=
ng
> parts:

Applied, thanks.  The BITS_PER_BYTE thing isn't an entirely bad idea but
I'd like to go through the entire codebase and do that rather than do a
little bit at a time.

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPy1hWAAoJEBus8iNuMP3d+iEP/0N4f370KMR/GjxKxuGgogMD
H1u9IeE8W7zlDUuggNmWX3tXei3ZocdnIEizIxTrLFlKO3jWuT4tYpqAr+kQ/9OY
+vLptJzdlh1bemE4pb9qZh8Ywv3MYz+BH3VtnqQdgOWHXllRPxveIND1MD5DEQNI
VHVwSn8vg5V695FQ9UgU2VEBov+HXmgUcOAkCNILKywQz7We39xK8VOdNYeX3Hud
7FRgTwIFhCYq7yByvr9PG9Sv1E//29VevxldDBAnSMHkC2/Le208CGRzcYpFaOx3
UWXOUz1S6EI7XfgGhb48M9ZXD9k90WPpR6SOAr1nMpJ6LGgXLIOqkr0zzdWZkIJG
vEupIetYGam4k56oZ0Qcnip1VQEuo+wNyPEiNFSCkZsX5oJGuYBGgBjAc7HxlQ4C
CPt/bqfogAI8tC3tulHouf0Kmrn/Aw9YsO8gXUca+2ZJXROD2d4T0B5TMU3h6aPe
5oF8LQqYQYB1rwsl1uwD45H58m5Xz+4DtvVWiurRrxcNXM9WbWKS49ZiKqnHsUef
TqjXTQZkm8vf/Z6NGA2RYBkoVeyAUI14nnAVP29hrqg8fNn9sNwfWVUUEKKDFAoa
WE7EZMdP1KwxT+bDIi5sFAl9ZrzrJjneiIf26b1oD2Dv5ph/mDLiqtS0nJ6jgmg5
McSL8kK4DKRsFWnim0P0
=uanf
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
