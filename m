Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2GPUCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:02:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53232 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab2GPUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:02:17 -0400
Date: Mon, 16 Jul 2012 21:02:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2 2/6] mfd: Use regmap for tps6586x register access.
Message-ID: <20120716200215.GE10774@opensource.wolfsonmicro.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
 <1342421510-10638-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <1342421510-10638-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 12:21:46PM +0530, Laxman Dewangan wrote:
> Using regmap apis for accessing the device registers.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBHNBAAoJEBus8iNuMP3dRD4P/0rge4DorI5gO0EDfNRcoU5n
uA4WO1ZzJU6EDnx4rn68DhJC380aZJJHhpVL73S19GLauJCWumbiUKV2GA/8o1pj
SjfVAO3wIe4KPFtkM+z6hK5apRWZYRCq+kl5HNwHP2k7zCxmZuA+3/d0lJnaDqR3
5klv80FeP00mRoOX5PW+v5ExnIAqT+qZfnZS/+GK5rJQZ/zP5BK9g97sPTDl7w2q
7i1QpdmVTO+5MOy6mudfM329y9bB6AIGMRNe0Wjew3+zdroggDFDNyadbRFX8cQ3
v56RatE3phRtRY59ju0kjTkRG9rEYcgn3k6OSqKQhwPI4DBub3WvcoFFgr1mu6XO
PulVRtAdXtxG9WWDdhtimJv08mN8p1/R9jv61hKLVt+xGgYGNaeJIRo/3Unx86Qy
xLhr7lgbWTaUReJWfTPgOf0GDC2vvogilleW/5KD/hOckxLg7AgMQscJ4c0jNzv1
7oLD1o3CVnkdANv79ZFU5NxTrgOAMw/A5HOoqzzFYxD9qUyhr8KRTTHh3zKzOmBc
aAZ7t2Dv94OwBdc0TlWgcls4DeDciFndoJamChZD3urkZIs+I508HVkQhl6dBQwu
eJ1k49kdoArDPQrlTbJCsGIvkcck1o8oEr8d5eSqjSHUI1wM+LBdTZDEkVlhK6Ed
emJP+Y+CnR8CS4JcgGTb
=GbUs
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
