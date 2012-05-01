Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2EARAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:00:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42463 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602Ab2EARAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:00:07 -0400
Date: Tue, 1 May 2012 18:00:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>, Saravana Kannan <skannan@codeaurora.org>,
        "Turquette, Mike" <mturquette@ti.com>,
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
Message-ID: <20120501170001.GB4089@opensource.wolfsonmicro.com>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
 <4F98EB10.2000505@codeaurora.org>
 <20120426084201.GF17184@pengutronix.de>
 <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
 <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20120501091334.GG15541@lunn.ch>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 01, 2012 at 11:13:34AM +0200, Andrew Lunn wrote:

> I agree with you as well, it is frustrating. Could we agree, that once
> this patch is in, we freeze the core until the start of the next
> cycle. We use the remainder of this cycle for porting platforms to the
> generic clock framework.

Or merge the platforms then do framework changes incrementally, updating
the platforms as we go (which is the normal pattern for maintaining a
framework...).  I see we've already got SPEAr merged.

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoBSNAAoJEBus8iNuMP3dDMwP/i1COcnT68R4PZViR8H8XBh5
gwnuO8Z1FrDp9IFh1UBygRiw28wDTqfJethts/Zk0xkyFLsEh3xQwUEiqnMKDhl7
Uk/Tt9g0ms2hbZzoPA3rA/sN1pheJsXT70krkeHfIS9cbSGCgiA9P7OWKPInbsgv
+s9rVP6LDMBORFo2y+pr/pv2ArxDrrgXPkQu1EbjlaavdSziDb0dyUHNQUfS1R+0
KGQnwuvCodsmGS3Zov5XPuIzRRP0S9c7zFNlfT56y23KcRH5KixiRSK0+fEGDrAg
R+oijBxubdy9CCPonrchCkApoM7s/R0te73zTFuALc1/EfCz0/Q2MPpuK59p1o8l
22K+i7FsysppdzRuh0obMCyHECCyXBrUMh+9fOEW6+liMrIzgr9OqwZc2OTFU7Rp
32iTM4ZrJ6lUcOhJKFCxIOkRIbsFuDiMqTwEUvi7eI/aNw5fdH69vZfpEH9o1bN+
bPvGNP/VTxNFpHmeCIpIm0G0lAxgkcK1WSuTU4Im+wI8F7KfLH3cQLxU3Rc0pi46
uo5cjd9gTb81SIp41WaVAyZpmwDu05f+J5gYlGGpOfq1BpLsDHZnlkgOnGaMj+2Y
JgtpiysOPGsmwj2DLnaeflpHhlfY3gGL3/fmf8YD2ZQYgAF2pj2UHjC+tQgbstTK
huJHZnY4qS+NhimY7OVp
=ylpZ
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
