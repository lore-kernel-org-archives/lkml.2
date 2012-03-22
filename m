Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2CVLeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:34:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39534 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab2CVLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:33:58 -0400
Date: Thu, 22 Mar 2012 11:33:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120322113356.GC3091@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120321222622.GG29317@pengutronix.de>
 <20120322111531.GA3091@opensource.wolfsonmicro.com>
 <20120322112613.GA3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20120322112613.GA3852@pengutronix.de>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 12:26:13PM +0100, Sascha Hauer wrote:
> On Thu, Mar 22, 2012 at 11:15:31AM +0000, Mark Brown wrote:

> > No, that's not sensible.  We shouldn't be open coding this into each
> > individual driver that provides clocks, and we shouldn't have clock
> > users having to guess at what scheme the driver author used to dedupe
> > the clocks.  As a driver author you would assume that the reason we're

> It seems they got dropped. Currently the clock framework does nothing
> with the device argument. But right, it could use this argument to
> generate a suitable name.

Indeed, and as with adding the stub clk_unregister() it seems like it's
better at this point to just code the drivers as we'd expect them to
work and fill out the framework to handle this rather than introducing
workarounds in the drivers.

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaw4cAAoJEBus8iNuMP3dg8YP/2NJCsHhOfv9UswymYuNGBqi
G/NZUWZQ5YT5NiZvS06mvHTRj3KOG1puxBSA3YCcvP/rolWPlycBs4yW5SQfZKy/
WpYNH4lpGwMvYaG5uiuH65tOINT6wOJacWcKCWbx7bVDg0RyhaWWsVV5GmEM4L0a
I2DuDnYaXlSQQ0qQwgdviNaavE6zLGKXX/ZvFjIqPxZFIHAtNTxXzIGrmGNRA9Ai
tUzlbHXYlSFyuwtIc9JFkhEdlXNPe/1Y2dbPDeFRs50qTXr1UdZzICGVv4AjFCAI
35yBktlQrnHDnWna5bIuBJRQ1T2Xi6EkVRqoxVOSzX042TFkwHst2pAkyvc2xG0Z
g/fA/Lm6DWQgNBuAL6HK0ZZiN3ZwZy8jopgBrFCY/n9K+bEwUBJ3jwrTW0z/Mo0A
foUo45SbRy+yydlFQbdRAYpmo0hNYgjb3eVVXhXn9gGhzf0BySIKfWWNvfmpZp5C
oOE07Q+Zr4kWZjUVqVj8Lclgxm98w1NSCaIi5S9UTqVE+76egoMW4TKYy9kQOABA
Qyps3U147nAM3sA/6uiSLm0kmYWYGY00JmoarTKeZfnt7/bEe7uFvslks6EZUWvi
fB/wfEbBltGnGY3AwMh43zva+oFYKII/BjcO1/Z+vQOWprqcbhFGSAJSBDLfR0ew
evwNVGfaedpOjDEHBs39
=B3gB
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
