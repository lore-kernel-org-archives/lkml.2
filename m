Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2CPTDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:03:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43033 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab2CPTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:02:58 -0400
Date: Fri, 16 Mar 2012 19:02:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, jedu@slimlogic.co.uk,
        lrg@slimlogic.co.uk, gg@slimlogic.co.uk
Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
Message-ID: <20120316190249.GD3158@opensource.wolfsonmicro.com>
References: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 12:58:37PM +0530, Venu Byravarasu wrote:
> From: Venu Byravarasu <vbyravarasu@nvidia.com>
>=20
> Fix compilation error due to including TPS65910.h
>=20
> 'struct gpio_chip' is declared in include/asm-generic/gpio.h
> which is included by include/linux/gpio.h.
> However without including gpio.h, TPS65910.h declares
> a member of this type as part of 'struct tps65910' declaration.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY45TAAoJEBus8iNuMP3dgPAP/3EqpFZfZ3/N079PssREmm5j
0L6al8fxhye/dAMQQ/EYIu/tzer18IeVhQhIdCKhEzJgzBRKXg0IOEYICRg0ApHL
4Vkbw38JHYDtNxTQmQmB9Zefvvk2n2dbhZWACYtssdyfsSlzo7p/DvJRdrlcvA+D
euzOBSmZnlQUJdfLHp8Add0XmvwyR0zevHrsnynGnNyl7dPVG2EvmTrcfCSthgbm
pW3VUtUCfANKNiQqwZ+GjPuhcAM6fRh1iFsKSJQQhkveqbYvNzvyIg77aG7glHyV
ozxvhjO3ptYlf8JVlypAYEx706Dl76CemwCg4O7tzEFoG8AP3yr5y2ROLg6kpJUD
eLz536/xQ8yhl10xDh7C1xgZxKOVx1yGH6JppPMJjEwmkf7KqQHPXTkpLUnuu2iU
+HXgYvDbjbARZYq5TdTkOOva9Ibnb7sLcqeo/j44Rlmo1CZaYbrmv53HxRTElThM
8FPNZpfWiXsvw3ezBc9/337DeOpfR/jddOxy8D7ZFczIzgKqNHaFoEf+fwO8l24w
+cAoQt3zLq3ctTj20jFoxsjFD8QirRyYmnIjESRZ/Mv+uo5t36OMWoSedpszCWH5
IjiPqT49lwGlO1g45TZFiylDCqdAfOXePwzAtDBfFu+FCOuwrrnEx8xtCjrc65Wx
qDf9s4NVmTQ0ALT1RoDz
=OCsP
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
