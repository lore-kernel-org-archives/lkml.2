Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2FRREN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:04:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45466 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab2FRREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:04:12 -0400
Date: Mon, 18 Jun 2012 18:04:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: swarren@wwwdotorg.org, cjb@laptop.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org, lrg@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] sound: tegra_wm8903: Adjust to of_get_named_gpio()
 change
Message-ID: <20120618170408.GW3974@opensource.wolfsonmicro.com>
References: <1340037743-12924-1-git-send-email-stigge@antcom.de>
 <20120618164659.GV3974@opensource.wolfsonmicro.com>
 <4FDF5E9E.6060803@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S5Rg6oz6PtEXgjQf"
Content-Disposition: inline
In-Reply-To: <4FDF5E9E.6060803@antcom.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S5Rg6oz6PtEXgjQf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 07:00:14PM +0200, Roland Stigge wrote:

> Basically, yes. But this would mean that doing via gpio, we would need
> to pull other stuff from the sound tree over to gpio to build upon
> because "my" tegra_* sound patches won't apply to the gpio branch currently.

Oh, yes.  Stephen's gone and reorganised all that code which means it's
not a trivial merge.  Ho hum.  I'm happy to apply them if folks are
comfortable with it, I guess ideally I'd be able to pull a branch with
the gpio changes in and then apply on top of that.

--S5Rg6oz6PtEXgjQf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP319HAAoJEBus8iNuMP3dxNMP/RSTCzNHazZgPQYBYgF5c7eM
4hjUK7NU5jJZdTWoPB54LyCM7RcS7IPJmw6+qWv3tDZpmW3sbNavwEaUbPckiC1S
x5W9AdV9EpqJaflXoW7o3HGRff8xDHqRjzEWNrPQiFdjINxXrPrlS8zlEup5bkEL
UrICoGQKHjTJD4OkPfdM7mwE9XPNd9darpqCvGf/jVvXxb3r/wKGtsLsUnzaVRAi
c47nwI7A6+fcrndhCh4k7xbwdjNpPFy0yElVq8CPEtfmzxftokYEWesjNXEYnT6/
l/CX+4ivcjBEpX7S2dJPel9qa3X8k3+3UEu7qNSddpLOpXuQ2Dh+0jdgC6Fpj8rk
3BrZmY27C4GUQlR9LXmSADf2LwKtA7Dh6TSyM94Oa8npNRyVA7CZNZyPAG/f+e4C
P1WqU5rB0Zl360PslfNFY9kaUjedz9PAcxc2vvNh2BSRfM4qfb63aujZ/6PlQRl9
xVzTKcLJDSGXyWzaJNH2YZE1fTD9VNBda8d83CSpGEFB2OmRKYlZEaMfC2B7qKxF
3Xx+6kKn7672rhVFHzORdqMjE8xtDQ0Z2AoLwPIrGt/pljxSSdvl3HaTkw5yy8aL
7R0Rq33WsnMNXB5YIRgkkD6WARhEcLciTq4a0FCaBc4QYykSqO9rn+QL6gIPnjLD
phWrTOQ4qPePO6kYGZQ7
=smN/
-----END PGP SIGNATURE-----

--S5Rg6oz6PtEXgjQf--
