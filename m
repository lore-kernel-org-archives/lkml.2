Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab2CUTHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:07:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44872 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab2CUTHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:07:45 -0400
Date: Wed, 21 Mar 2012 19:07:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Paul Walmsley <paul@pwsan.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Message-ID: <20120321190741.GL3226@opensource.wolfsonmicro.com>
References: <4F6A2042.9030302@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qo7zVO9a9OQ5oQtr"
Content-Disposition: inline
In-Reply-To: <4F6A2042.9030302@codeaurora.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qo7zVO9a9OQ5oQtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 11:38:58AM -0700, Saravana Kannan wrote:

> >So it would be interesting to know more about why you (or anyone else)
> >perceive that the Kconfig changes would be harmful.

> But the enthusiasm of the clock driver developers doesn't
> necessarily translate to users of the clock APIs (other driver
> devs). My worry with marking it as experimental in Kconfig and to a
> certain extent in the documentation is that it will discourage the
> driver devs from switching to the new APIs. If no one is using the
> new APIs, then platforms can't switch to the common clock framework

These aren't new APIs, the clock API has been around since forever.
For driver authors working on anything that isn't platform specific the
issue has been that it's not implemented at all on the overwhelming
majority of architectures and those that do all have their own random
implementations with their own random quirks and with no ability for
anything except the platform to even try to do incredibly basic stuff
like register a new clock.

Simply having something, anything, in place even if it's going to churn
is a massive step forward here for people working with clocks.

--qo7zVO9a9OQ5oQtr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaibGAAoJEBus8iNuMP3dIVMP/36TADmR0rj2A+LkfBqA+QE2
K/+IO+gX8K1Hl0j2DxasF7kDVici6nsgtD7fVpBDnuJQyNd9JHM/a/nA8HW9TX14
wQ1OPB4jOlx0/8SI/4a4fz+FDG/MjLiZTMHej8p8uP1ElC+OSdbwZ3lg86MZoLTJ
8Ld6hr3+rIWj7+/a/R0gcBL7DndIHX66xQ8qOSIi0UhE/JI04v0WduIUZkgRxJAN
mlARobneDCNQAwLlaPXrWxuKs1uiVwqRzbizC+YbaW/NsE6v6beUCvkeWThN8T/g
piEu4dYg7S1R0qhebnVZujln4bG1WkqMIRv28rsC64YxoNas8qCjBwHUyUDq3cP1
h+06e8yJUS7b8x/9l/1QzAO8NK2M6vT1BW1WNgbTeUjCh3uIyG74ftHKmV10YawW
fv6t+L+d/3EayZch9o0no/jWt4kTVWHKujRK7vFiqlCYtxQm1VicGkzY4TqmlvMT
wCUitBglQoAhXU3GH3mKfilrw2M2esd68S6a2bQMrM5U+GFKcrEEL7tAC1bbRSUo
zaWswHf6b6UTeAz/7o4Xya4TmdYv23ZlQcb4rTf9XQB81msml8kc8g+nDnfrcbPX
bN35B9WLH/+fhHzsERbvBll8dvyLGOZuTOukMEC5pdZcbHERmHCdJDCxcxBjmu3D
D3m1SLPZX/aKztHTyU+2
=C+lG
-----END PGP SIGNATURE-----

--qo7zVO9a9OQ5oQtr--
