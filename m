Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2GQNf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:35:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38009 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab2GQNfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:35:55 -0400
Date: Tue, 17 Jul 2012 14:35:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120717133550.GC4477@opensource.wolfsonmicro.com>
References: <5003FB7C.4030509@linaro.org>
 <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <500568D9.10805@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 02:30:01PM +0100, Lee Jones wrote:
> On 17/07/12 14:06, Mark Brown wrote:

> >It's not just about having generic bindings, it's also about having
> >bindings which have some abstraction and hope of reusability. An awful
> >lot of bindings are just straight dumps of Linux data structures into
> >the device tree which don't make a terribly great deal of sense as
> >bindings.

> The Device Tree should supply any platform configuration which the
> driver needs in order to correctly setup for a particular machine.
> This is exactly what the platform_data structure did before, hence
> is is reasonable to assume that whatever information resides in that
> structure would be required in the Device Tree.

An *awful* lot of what people are trying to put into platform data is
nothing to do with that, it's just the generic data the driver needs to
be able to understand the hardware at all.  Things like the MFD
breakdown, random parameters of the hardware which you can infer from
the device name and so on.

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBWobAAoJEBus8iNuMP3dysIQAJUP9/WdJ9VLTOG5bA3f/tLD
iXDgfrm/9QJVz5POnOnjgR3fnrW0W2VyY9huF+1SBV+5IGMuCp55GhqEXruhYs4h
CLfMvRsBZ2nAZZMgNWr8vDIMont2Q73cM/HZB1nWHSUFwtbOsq8pQrvoe9SF7/0Q
78Q0MTWKDQvdfNfzjeF5ZItcN9GdezSRvcKhJN/tiiSeEsN3eh3ztZuEqVgLUKx0
ODbCR2g6w4KZfxyOkRuZHXzNX4OnDr9SXaH6sUZ8Axf1X2d49AA2Cg1ijijeAVV2
MI6mJSOERDV153zWUIOHLOyApbMZdsg/InZtFsMFwjkbs5G0reb2xCsbFZVBhsog
37OyD9W5TixQWTaX0HY0mYt4lJkdXyQ7yEFRadCkUWnjb7M2PkciY1NscmPJPgW8
ZATOpg643ouJ0w2q4Q9yaKQVG+8mQFcgahzYudYujzHB8KOV9AY6MJcY/w3hSY9X
V21+YHXrvwiVf5e5QlEt275gTUIXz9dQHo2LADDcj7wAvpkB8B2U6K9np+ILTVcy
cl+D4aSB7N7NVlLqbkVliOw//AeHLfGVyowcyPboi3P6BbAyr4l/NJ/hBiv3BxlJ
CJvcOggci2vnYLYLRa1mPyio3Qo6q47oycTL9t3wvvU69RynC3uVflDNSjHCQHAA
UDowXAzqLfqYRFlgSjPY
=C2mU
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
