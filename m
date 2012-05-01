Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2EASTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:19:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56799 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab2EAST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:19:28 -0400
Date: Tue, 1 May 2012 19:19:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, "Turquette, Mike" <mturquette@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120501181922.GD4089@opensource.wolfsonmicro.com>
References: <20120426084201.GF17184@pengutronix.de>
 <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
 <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
 <20120501170001.GB4089@opensource.wolfsonmicro.com>
 <4FA0258D.8020807@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <4FA0258D.8020807@codeaurora.org>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 01, 2012 at 11:03:57AM -0700, Saravana Kannan wrote:

> Sorry for the annoyance I seem to have caused. I too have been
> trying to get this in for a while before the other platforms started
> using the new framework. Not everyone was free at the same time and
> it's taken longer that I would have wished for.

> I did my best to limit the changes that would be needed without
> making my patch useless. Appreciate your understanding.

To be honest it doesn't look like your patch is a particular issue here
- there's wider process problems, for example we've managed to go
through most of the release cycle and so far the only changes showing up
in -next are:

Viresh Kumar (6):
      SPEAr: clk: Add VCO-PLL Synthesizer clock
      SPEAr: clk: Add Auxiliary Synthesizer clock
      SPEAr: clk: Add Fractional Synthesizer clock
      SPEAr: clk: Add General Purpose Timer Synthesizer clock
      SPEAr: Switch to common clock framework
      SPEAr13xx: Add common clock framework support

Mark Brown (1):
      ARM: 7376/1: clkdev: Implement managed clk_get()

Sascha Hauer (1):
      clk: add a fixed factor clock

viresh kumar (1):
      ARM: 7392/1: CLKDEV: Optimize clk_find()

and obviously there's quite a bit more work which has been going on.

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoCkYAAoJEBus8iNuMP3dxX8P/A3lmQxfR7RRTozjmT/2sTl5
O51RAWbnAWkH79k6BckWRciIfa6xrbShOx7hsvv4D4Doj6pMgYKfXrKdz7aFsP/D
6Me6olu4COAuNcB8fLKxrnLop18Ls0ffYWh5ZqrRjY1pE7ETJtgftjcT0+/z43GR
tEuAwS3eTIu5x0geZYvwih4vDQkullXTk/j8gZL2AnUlAlBVG/97yXcsxXQX3RSC
/uWmqEb8ujLEXbS5YQY94i0AAwdxlr2CjKg9X6j+z8BJsebB2VTasVWItgntg5yf
sCCbcxgSiCZqwXeRr151FLNqu56xjSg1pvC5k53b9/VouLFQZbZTDw6Uh9Ag+rYK
bh9Hse73TBkhBJxuGLNUaprLRxhX7oSIuyMn7LCQbG5mUmFbTlQ+Tk1488i6X7jH
+iJQuOBDD/MUd3qAg4IDaFWvh24QTFnrPiAqNIXg9AoLD93Zp4vjXvu/WrQGjtuq
APs2iUzze20OwgGlM3vWbXuBiHkSKoZbh+MxKKpFmgQF/eqn3O7IDs5xy8lRFnTS
CfKQDCkz2jkp9ff6d+Cb0wxnJvK2ELwykqxwBnDbK/e6WK250hWQIkacIa+G1pHL
ZJYa89NMlaencCUht87BOtzsFxe12axKRPcmoCKR6U+wr8okiWPlA8pDUK+jhBAE
gz5kvh37oFFQFIimtySU
=xm5U
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
