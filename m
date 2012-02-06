Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2BFQjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:39:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865Ab2BFQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:39:08 -0500
Date: Mon, 6 Feb 2012 16:39:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: twl6030: Fix voltage selection logic
Message-ID: <20120206163905.GQ3070@opensource.wolfsonmicro.com>
References: <1328253878-12609-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bEjdSXxHv0Az5++U"
Content-Disposition: inline
In-Reply-To: <1328253878-12609-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bEjdSXxHv0Az5++U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2012 at 12:54:38PM +0530, Laxman Dewangan wrote:
> The voltage selection logic for the twl6030 smps fails if
> min:max is such that min < 1300mV and max > 1300mV although
> this is in valid range for a regulator e.g. [x, 1350] where
> x < 1300.

Applied, thanks.

--bEjdSXxHv0Az5++U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMAIiAAoJEBus8iNuMP3dnVcP/Ro6LSDpHv6w2rrIb0cT/QKo
Odjj6g431wjMkaodY9MmGPaDYmNmh5mS3wanQ7+fAZ9GmUDoy23nIIYOMOWona82
1aGnAZLIWaSkZtheRnsCMT9P1kzbwDKxvpKeij9Cifu+9+yh4yLtpHEa/ZCAFSHx
BIz4F2Y2JY9WkzFHox8DUmxON08+nPyH8isUxr0NR1jfvaQZD49wuJDnaP4ls5Ea
tBa0bkjzNrk4CoxT8wdpHXiOmXW4QH+b5DF4+klxz1ES7d/nn3a2MyEBO+yQtYdG
Aun83jmg4i2eCXPi6yz414zW8g9q8sneeoTaUjU8XizicsLJs7fk99vAvs/RbBEU
Hlfvnj39C4jR5Llh385xpqpHNtcAGF9ihz1qKPaVIX6idwo88TLrwRxW1A0nJqxf
MjTktZXXG3wyTT9hYC32lBbmOdgBf5GmgxzZGpKY9RVcV/5uJuHfLXM6+Y5lgRr+
0l0VLeMAWOq6lTUvXoeLn9lFEF03rHrNHc1DEhNUnwr2DMT81ZRGNvcfPkyg/HGa
xLMqXJAHOWLYAzSO9i8A/lRETEIJMiIBb/ORaFKd6tTmZc4+4XnnQXWRR954N5wu
K8mCKzfnTcM0B09pb5XJocD0D+qkFRuXCOxrB+T/sda/cDQ5fM9k3BEXY96DZmIO
3VvaNx2nIyqbV1pSbTGx
=Vaog
-----END PGP SIGNATURE-----

--bEjdSXxHv0Az5++U--
