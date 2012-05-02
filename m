Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2EBP2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:28:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab2EBP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:28:33 -0400
Date: Wed, 2 May 2012 16:28:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
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
Message-ID: <20120502152820.GD5722@opensource.wolfsonmicro.com>
References: <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
 <20120501170001.GB4089@opensource.wolfsonmicro.com>
 <4FA0258D.8020807@codeaurora.org>
 <20120501181922.GD4089@opensource.wolfsonmicro.com>
 <20120502015650.GE17311@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
In-Reply-To: <20120502015650.GE17311@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 01, 2012 at 06:56:50PM -0700, Mike Turquette wrote:
> On 20120501-19:19, Mark Brown wrote:

> > To be honest it doesn't look like your patch is a particular issue here
> > - there's wider process problems, for example we've managed to go
> > through most of the release cycle and so far the only changes showing up
> > in -next are:

> I think that "wider process problems" is probably a euphemism, and I'll
> take responsibility for that.  This has been a learning process for me
> and I underestimated the percentage of my time that would be consumed by
> common clk maintenance.  I'm trying to rectify that problem now.

It's not really a euphamism - it really does seem like we've got all the
technical stuff proceeding reasonably well but we're just struggling
with the mechanics of actually getting the code into -next and on its
way to mainline.

> I was happy to push my changes to Linus directly (as discussed in
> previous mails) but I'm starting to think that maybe having Arnd absorb
> the clk-next branch as part of arm-soc would be the fastest way to
> assist platforms that are porting over.

> Do the platform folks agree?  Is this suggestion sane?

Seems to make sense to me; if there's some bits that are less clear you
could always keep them on a branch separate to the one that the
platforms use.  It's probably also worth getting things into -next
directly, that way integration testing of bleeding edge stuff can happen
before it's been merged into other trees and it's hard to change.

What I've tried do with regmap when it's been possible (it's not this
time around because the stride changes touch everything) is to have
topic branches so that people can pull in only the specific bits they
need.  I still end upn sending a pull request to Linus even if chunks of
it have also gone via other trees.

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoVKNAAoJEBus8iNuMP3do0gP/iJq5s/X2LVX/v+UL/QXpx+U
AYkF1WzSiZapliqZiOloibxOdJotmp81QSvp59Cbuv7OHi7pi2FYChS7OMtdHJAp
ZTGoDOsT0Mvj8RwOLRjmrVS6gHbWaWa5HSld39QZE+JPjgAC6kuVvLAuvpSnsGry
Wqx0Zzl+BXrFcbShKxRlBffRbVAnmH3/zKogUs/Xn/SW6lY1KF2QoLQJD+mq7CWI
DjusZ42Fkm4aAoGGsCBJI0JU5zYkL4Xp76Gh4rivcfSBP0bjhVTWQq6iyzbuH7/e
+8ZTubJ8PeJlPXmJXfl/3WNeAfnEWmbkg8qFXQACDl6e25f/SYnEA/C4VdADS2ff
lGPOk95DI2WiHCKknTzOtHV2HtDVaiKbrHh+FQbBMmTb6A/9ji0cY66FjmpWh8bU
e8mMp5b/Q3Wd5FUmLcS5A/HBtTBEYZ4bqlan0mmijBtT3xAD7W6mTNIkk2V36ooy
B0yQ6hSK5u+gSnorB9ycCa+rCvr1f53OmwTfDvgcIToeah1jt/BWRHILp3dLHyHp
iZKZ5nIyuWmNNtLNo9Qe+2cN7kS03PpeZxMaFojDOlO4dM2mU+XI3CGbrbc0KLXs
kOYwxyz+sNW4bLgK6wQuqmpYWeLNOSdFRx4TYDvUUzVRR4uqz7NhDSgpZF/pAK1T
wipxQGhy+8EAD4ni8fyw
=RqCu
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
