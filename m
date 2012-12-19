Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2LSKcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:32:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57356 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab2LSKcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:32:08 -0500
Date: Wed, 19 Dec 2012 10:32:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        svenkatr@ti.com, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, lrg@ti.com, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219103206.GQ4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FilwpOHBrTVNlmJ3"
Content-Disposition: inline
In-Reply-To: <50D19463.5010605@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FilwpOHBrTVNlmJ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 11:18:11AM +0100, Peter Ujfalusi wrote:

> Sure. It must be a clock driver. I already have similar driver (for McPDM fclk
> clock) for twl6040.
> Let me check linux-next, if CCF is there for OMAP I can send the 32k clock
> driver soon (after writing it and testing it). It is going to be for 3.9 but
> we can roll it with us I think locally to resolv issues.

Well, we still haven't got the foggiest idea what the actual problem is
beyond that it's probably related to the 32kHz clock in some way (unless
it was one of the other reverts that coincidentally made a difference,
but we don't know what they were) so it's unlikely that just randomly
implementing clock support is going to fix anything immediately here.

--FilwpOHBrTVNlmJ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0ZeGAAoJELSic+t+oim9OhcP/iUW16vAlKxNUVK2rI3p3Gmb
obq0fIk8V/6l0YMpvUrRYWv9sVgpsFOVM79M8EJF5UN1rHJ5LXwdv3XinIWaqVYO
0ixENxjHj2F3z2xIvwvEjmQTX8ZOrJymJo63/ekufSsKP+LKOvxSNxieXop7WTg7
2Ifa66tu3qR+dXfZIZSkUkPBRlnrcjaFUFDHQUJXwf8GWcSD211XQ2bla21cIemG
fkPloPnvPdn4vWguHaTJs+H4jo4ZB2FqbKI31PZtG5hDzN+ScYWK0Sp05qAmrhHe
REiQ2t0DyqozNkp27ftO8FDWjf9sBI2cYTn0gQpzdp26OG+nGPUoXBPyMvUD0FoS
pSW4EXZ0cRWRdDiQXUH9938qadHgpM0p4pVBLAUnY6zrM+mMTUa+LvjGOpWE5Tj4
l74C2112yLlkcN/jpniUP2/YAWS+P6bBoQYeWaExRTWEgjp0olibEnpI88olGtax
65Ql7zqWPWIUzyOGaJsSKF10Iq6pDTtjqycQmRTUY0Tzv1bkOgBv37GrUI3fnyto
xAjoc8gi+ZiIzWw39KxKlJQgkEpS7pYi1h+5k2IuDbD4aQNxBQPtNirDfh+TAoBe
PC0R29rF5Yt9l1UaD6pl2w11nvB3biVWqTmK+2e+LRrQbsRX1xicJe8JCvTVm3Oc
hslRkdTziNNcH5e9i48G
=2qCP
-----END PGP SIGNATURE-----

--FilwpOHBrTVNlmJ3--
