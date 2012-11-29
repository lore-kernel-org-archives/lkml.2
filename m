Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2K2LYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:24:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab2K2LY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:24:29 -0500
Date: Thu, 29 Nov 2012 11:24:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121129112058.GH32691@opensource.wolfsonmicro.com>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
 <20121128070332.GC23378@core.coreip.homeip.net>
 <20121128085731.GH2013@gmail.com>
 <20121128163105.GA28698@sirena.org.uk>
 <20121129100808.GW2013@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fh0SynPkUvrWGMR0"
Content-Disposition: inline
In-Reply-To: <20121129100808.GW2013@gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fh0SynPkUvrWGMR0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 29, 2012 at 10:08:08AM +0000, Lee Jones wrote:
> On Wed, 28 Nov 2012, Mark Brown wrote:

> > The I2C subsystem guesses at a compatible string by default but it's
> > much better to explicitly set one as conflicts do arise from time to
> > time (eg, Wolfson parts are called WMxxxx but the WM prefix is also used
> > by at least WonderMedia).

> It uses the exact device name, rather than guessing. I don't think
> you're allowed to have duplicate device names in the system, or there
> would be clashes at registration time.

> The system is the same for platform data and DT alike.

Right, which is why this mostly works, but it's still better to provide
an actual compatible string which we can be 100% certain will avoid
conflicts.  This is very low cost when one is already defining DT
bindings.

> Hence, there should be no need to have a compatible string in any i2c
> driver registration information.

We're getting away with it at present (and frankly nobody's going to
build in two different drivers for a chip of the same name for practical
systems anyway).

--Fh0SynPkUvrWGMR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQt0WpAAoJELSic+t+oim9BCUP/iIu4K6DlJoT3AQOzsGUJxzP
73/7CCtAvxIWHeqwmE8geGh83LwQJHfP4N6wEtNBaYVlCShzhakjMjZfdjj9KHaY
V+JTcpHcJvaDYBASiZ+2BZ+c/LunvDeHa6k23cRF0t8r8hF20WPwbVWHjvOwd3Do
f6GlTDNvVWpN9XOxeMofuy5kQRRwMfYWy0aP8Fy8ND+zE/Rw96PdWyyiywAKrMHv
SdNs1qrxATa+udO/IQGISi5CTiW4/BxKTmU8zFH0QVotlK6PkJa9KI70Gz+3SGp7
JNOgCdViezhsiMExgVNXXY1vmkHOUS2cqrQ69UGIqD54hyrWhnpD7BChBSRT0xd1
nQDBRJxQQeOPkx2njwAQQmrmzNAPGn1FnfFGWmINpkjryLpYtLYjCjo8MXTygGOZ
WnsNXPHstMznHKi6qu7Cg/luf5lRiKBXi9SN6oo2tZgzoaLKm86f63iMJg++Q2wF
7lEU2qeOhvKzs2kpI7+jQb+XIjoMdyoB1iufoCtvavt8aprohNr1d+3hcHhFVBNm
LW+zchxJb8fRukOS1w0wHpPQx3hUz97M/qskcVkTqRBHYlxXWZRFy728TuL3lVNs
q0PT++vvVnRTNSXyhOD5TNfcG8XxoM3wUFBzAIBc9+x/qniDc+3OgSO5WT8LDQJZ
OQKGeq0zvT91QLv6172N
=XvxN
-----END PGP SIGNATURE-----

--Fh0SynPkUvrWGMR0--
