Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2GDPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:48:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40382 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340Ab2GDPsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:48:24 -0400
Date: Wed, 4 Jul 2012 16:48:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: ab8500: Set enable enable_time in
 regulator_desc
Message-ID: <20120704154821.GG4111@opensource.wolfsonmicro.com>
References: <1341369105.10587.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0ZU/rjo5v6h4DpE"
Content-Disposition: inline
In-Reply-To: <1341369105.10587.8.camel@phoenix>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0ZU/rjo5v6h4DpE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2012 at 10:31:45AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Linus,
> While working on this patch, I found in original code:
> ab8500_regulator_ops set enable_time callback to ab8500_regulator_enable_time,
> but does not set the delay in ab8500_regulator_info.
> I'm not sure the delay value is 0 for ab8500_regulator_ops, or the setting is
> just missing.
> Anyway, there is no behavior change by this patch.

Surely if the delay is not set in info then it'll introduce a delay
which wasn't there before (but which may well be a bug fix)?

--B0ZU/rjo5v6h4DpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9GU6AAoJEBus8iNuMP3dvNAP/0cHEimgjEpqED26CfaXlOoY
ZkblmM7AfVQDtICJHPjxEgHPyU6BXdZeg2wB5lyCAdZzqFeJ/7lOY3SXv1WfLQ1B
jKgnf6XLQ1demNGNLTJpvI00/UkN3cYab8NlOgkQticfYeXhLR2no/8KVBawK0Lt
DedNOukKfxaBCHf4KN8v5+8Sv2JWvBkUZF1ZRwwB1DVOQ90UcidKWqto7i8splVz
1Xe6G5OZobmOxgCbPQevMWrdYl8dWRBL/OQKJY1SgjYTIJMwJw+zaAdCFKCjyzid
F4X+LXLcLgtcHqMoABgxigQwBpH/S+o7cSG0vGZEgcYq/p90JilJJAxQVJwZglJP
AAj82KvuzAAHa59dMpMMzJL4nJR7uKmygNeK2w0OpxZSDTgY+4lVDT03v5wEnFcv
HM+TCKWQmKSJDi+YYaoOmLR5dRybPzOZWqMXNkpD0Ht7CK/Bcla+IWzx3lWKfN3M
TFk44Rml8q22qTxSRpoML70CmZENG6tY7sN1Mg4GM3Q0KshoQbSoOpj8NqzyXLeU
EoHNcMuPQE/oNdw3zCoZhM5pesk1eaz2gfnop2H1ApBE0DkiZvp4kkiy66sDZx80
GsurJl4xW+vM8x2Qrzi2wJXhVId7TrBQhEk9oSbSQcouZe+PqOqBCHTpjBt+mLsf
fnL7UAmhDkdzTEWh/iqA
=+UUg
-----END PGP SIGNATURE-----

--B0ZU/rjo5v6h4DpE--
