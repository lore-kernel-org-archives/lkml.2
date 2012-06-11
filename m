Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2FKFiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:38:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54943 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2FKFiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:38:06 -0400
Date: Mon, 11 Jun 2012 13:37:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120611053750.GQ4218@opensource.wolfsonmicro.com>
References: <1339391690.6612.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z87VqPJ/HsYrR2WM"
Content-Disposition: inline
In-Reply-To: <1339391690.6612.1.camel@phoenix>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: Return correct delay time in
 regulator_set_voltage_time_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z87VqPJ/HsYrR2WM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 01:14:50PM +0800, Axel Lin wrote:
> rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
> The unit of ramp_delay is mV/us.

Applied, thanks.

--z87VqPJ/HsYrR2WM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1YQmAAoJEBus8iNuMP3dLAgP/08I8duy+CAhnY2/I/ZUPpJE
TYLlszeJyYrSvgqfgx6UZuPHdPaQk+nvpPvUFIvuqS31vKKRCzr73z6RV0rPz7wa
Ocnhj8tDvi6gQ83sFXPnKKbvgWF1JeAxNrMdOwNPYdCKAIxgsjGZ84UkjPT7o+7v
vpxm7j6LBlQzumWoJhMkNOkRM2/CHhlQsv+j9+U4RH4Skp57UCJpMLPHgHAUV9nm
defbW7MMWiztVsoip4khYN2SgbS/frW0c4p5c6ZcPPQGy3kDpT9MqRrvR/WdgQs1
7Y9ZWBOETAOMDsTQtbO1H11go7IwFj4HZleV0p9/ilg9kfvRmPfwi4FE77JJJ4hg
924LGy0UDdWmoHTEo49JZ73cAr78f+h7LRJRkVJE33HVPIaukvgQ6n7cQiqeKK2I
vXazqRYnsQ+cjBY8BJUR+/BAF9HZmbBa7m6+A9cTG6Ekrd5E8W21KudG4OFNTvY2
gnvKO7Ww9m1m40a3yEnKEaHQ1gyzIh266WFDINJZnTMLkIV4D/OEVH0t/QIj7gS7
ed7paqRsgZ+JBLXJXrZhNJiqS2jFbAa3v7iELpGCnyVM2BiwIjtEUMh5dhc6D1Z0
Gw9sX/wnlUPi0jUhKdB51Q/ngvz8AUnev8+bHxUCCvMU0/7mfr1qfYafp0xK92pS
4YUjCRmoYGXOjNwnEymg
=9UgU
-----END PGP SIGNATURE-----

--z87VqPJ/HsYrR2WM--
