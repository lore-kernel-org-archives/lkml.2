Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2CUT5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:57:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56043 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024Ab2CUT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:56:59 -0400
Date: Wed, 21 Mar 2012 19:56:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
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
Message-ID: <20120321195656.GN3226@opensource.wolfsonmicro.com>
References: <4F6A2042.9030302@codeaurora.org>
 <20120321190741.GL3226@opensource.wolfsonmicro.com>
 <20120321193304.GO9859@atomide.com>
 <4F6A2EF5.3010008@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rzq/nSLlHy1djmXS"
Content-Disposition: inline
In-Reply-To: <4F6A2EF5.3010008@codeaurora.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rzq/nSLlHy1djmXS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 12:41:41PM -0700, Saravana Kannan wrote:
> On 03/21/2012 12:33 PM, Tony Lindgren wrote:
> >* Mark Brown<broonie@opensource.wolfsonmicro.com>  [120321 12:11]:

> >>These aren't new APIs, the clock API has been around since forever.

> I disagree. When I say clock API, I mean the actual functions and
> their semantics. Not the existence of a header file.

> The meaning of clk_enable/disable has been changed and they won't
> work without calling clk_prepare/unprepare. So, these are definitely
> new APIs. If it weren't new APIs, then none of the general drivers
> would need to change.

clk_prepare() and clk_unprepare() are already there for any clk.h user
and are stubbed in no matter what, they're really not a meaningful
barrier here.

--Rzq/nSLlHy1djmXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPajJsAAoJEBus8iNuMP3deHAP/1y36//PZAWnihTtgIjiK9EJ
T1YxJlZ2R/RAOmVzhbaDJZdPdt781dOFwo1WwgIrc9W4vdvM86sSrtuZrRpVbMfg
qlBDI8oMP7EfRr1bC/n1ncXKXoz4v0uf42tTobdIkuFauPxt99GZetCKGxGKGl0h
GsoZO0HTKXYeb9XG6HDmmi0aS5f7NAszDM/t/f4voKS2ctgDO8s1WaUa+dUTiMq3
0BHUI2dOTBYRHoFS1MKjGs/8RU4xqPA1DXx0M4tK8shqu4cfA6pozUBk2qd6LGM7
ut1xoi1DgOamSNicG7CDuLOUzmH0d7bkl8xSOTZCj9C2NsT8AGOuOKHIEDxV/vxG
djcMFzazO5SZYFO9dMbUE9ZBE21pB2WzYWr38cHZFO12gaxnJ0JSF57yXtuTOpyF
x4L1TvatWiZqEVDQaFkuofC5cu+zeM4nZjmVjAbFPK0+GAgWBAnSQXOc60rXpauo
p2tT3ULAXS+nZrxcyMEkkgxTMeDwFROdQ8ZH7R7PiSGl2zN48v3yYn/BKDaYta3f
/6RthPG25j+iTBg+BRY8tXXJSFZ0QAkbhlbf3M3JGUZhRbsPhVDwm6kdZ6dW4pnj
CDXWciBfrPXc6uchOKB8K49qnpO+2oI8p8iJuzAMo6x+/UvWLfA9Az/lO9sg6ATd
Zw9kVSRc4wwq0mGWy4zx
=nqVW
-----END PGP SIGNATURE-----

--Rzq/nSLlHy1djmXS--
