Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2EIOzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:55:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33668 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891Ab2EIOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:55:10 -0400
Date: Wed, 9 May 2012 15:55:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: tps65910: cache register when we need it
Message-ID: <20120509145505.GY3955@opensource.wolfsonmicro.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
 <1336569057-3890-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lPJ5i9rX1WvdYcWF"
Content-Disposition: inline
In-Reply-To: <1336569057-3890-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lPJ5i9rX1WvdYcWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2012 at 06:40:54PM +0530, Laxman Dewangan wrote:
> During regmap initialization, we do not provide the default value and
> hence in place of caching register during regmap_init(), cache it
> when actually we need it i.e. after reading of that register.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--lPJ5i9rX1WvdYcWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqoVCAAoJEBus8iNuMP3dBJwP/1YKkTCY1SmXNZ6urjAAfDUF
LQ9Kh+4xfZvXomPV7H1fPMkxACruzQGgknrDF6S6CO0dY8rBHDuRG3BKBwlgNMOA
V/B+bUSMcTPTmOrbPHMgB8hkAo5D9dgs9PnF3+sMnrt3iqm9YpB/2b02olO4kOXR
obh6QZyHjSELhayYzDqdjV5SYzgCbIp/Iqp0aR4VD5eDgqF6Q0Kp4JuQgu6E9xFS
wLmNBkspqFDO1SIh5G8E3pzCGOLUa8T8THLOBYWYCJsDnWDdWyuIQBXUh8Gkd/zD
KeqIylEQurgt5gM8f6XcPlxNsejK3TrAUi297gpPINFyxA2ajm4njE0bn5XCWi+m
Ry+iHJsn405wv2vaWyX/crKyhbLHmS5OUfj9mzcpjsFGegrCkXYckS/sQ1WRJjan
c06NLHV4OzaXm5MJbyz1vbl/dLetp9m/IhE3KnI73SoyikiGeNdesJoI3gZtQ693
sbYK12OEsLEMqwa+jnukB4J5XXDm/iQxLtsT2AYVvhAGOH50uXMw1TbfiQ1RYeji
xxJJm8gOKazqvVwcZjU69RPXHJpVMaciY16vaGLYhbB0yZ/Ga9FwwY6sCJSIFHZL
DDrkqeEiLwChrsZYfaNSswRxZNvZGMoq3cnfUYm1uRbVwKCuo486Q1us75JCZhUy
pcju3qdOEdHZbnd6lAqW
=eQpJ
-----END PGP SIGNATURE-----

--lPJ5i9rX1WvdYcWF--
