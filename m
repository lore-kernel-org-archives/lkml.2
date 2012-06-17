Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab2FQUDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:03:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41813 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154Ab2FQUDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:03:44 -0400
Date: Sun, 17 Jun 2012 21:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps62360: Simplify
 tps62360_set_voltage_time_sel implementation
Message-ID: <20120617200342.GO4267@opensource.wolfsonmicro.com>
References: <1339137332.16616.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOh8F6DNH/RZBSFD"
Content-Disposition: inline
In-Reply-To: <1339137332.16616.0.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOh8F6DNH/RZBSFD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 02:35:32PM +0800, Axel Lin wrote:
> For linear mappings, we can use below equation to get the voltage difference
> between new_selector and old_selector:

Applied, thanks.  There's a new framework feature that Yadwinder Singh
has contributed which should allow this to be moved to the regulator
desc.

--hOh8F6DNH/RZBSFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jgVAAoJEBus8iNuMP3dKDkQAIq1ZyU4kpxI9cO6qQql52Mw
MGQYcrXhDIPL1V4lETWHQ7EgEah+Y0LhFURFovDUr+wp6PpGl5I/lCmmcxRAu+Ct
WcWiizlUMOatLpieZs18HCdyIQlAzLoYpiCjlC5jRLITpyqHTnB8qt2cGF/vaZlh
pfw5Ivuw1rPS4F3QkTqTcOuy3eshPnAOpT1/hZTTMkRflmHcTIlwDq+el63cjnOy
z/qXWEDTdUMND4a2MDg6AbydJr2vpR4RgTEgLWCJ51UpoTRhxZ9ANzja4snSRcK/
YFYRJ+cLOSwDwLkwQfpoM2pmeNpc0kRJ6Xo2WWQqgwOIRPHM9ZaJVzAi83uVxENE
QqJUP3/8hto+sIOnesP4bnTnjYW2mvfNbD8w7WTOT6uu+1D5TNAd7+Ije1JyXrQL
Mtg4ZgZvMg6h73RGCgO6WBGSnhFQmj4EKvwPkEVZGaLR7OdGB+G+5xcftjDD5I7e
Oj+YafWIU6LEiVOw7lxb+zykoScFXD69UVpv0uW/2DR9yBTpY/u3pn2W/aoLSSp9
gWdd+noiUjMcUeL7LEvrCEKCcgZh/Z0ayTo3FHE2C1XeeyqGn//UtBfnpx/75q3Q
3f3SsVcyCFnFAywEhvUr9L64mt5Ntq8XIs8EsRcLq/qT7spGoHQm5YyPj98O71Fw
Bo4FVLwSCvoc1IVjjKe0
=aG5o
-----END PGP SIGNATURE-----

--hOh8F6DNH/RZBSFD--
