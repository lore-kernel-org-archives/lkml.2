Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2GRLMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:12:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50094 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab2GRLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:12:29 -0400
Date: Wed, 18 Jul 2012 12:12:26 +0100
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
Message-ID: <20120718111226.GH22739@opensource.wolfsonmicro.com>
References: <50066739.4010206@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
Content-Disposition: inline
In-Reply-To: <50066739.4010206@linaro.org>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 08:35:21AM +0100, Lee Jones wrote:

Fix your mailer to word wrap within paragraphs.  I've reformatted your
mail for legibility.

> I agree, but in this instance it really does stand to reason.

> 1. No unified bindings currently exist.
> 2. I don't have time to create them.
> 3. It will probably take quite a bit of time for someone else to get
>    round to creating them.
> 4. The bindings I'm proposing are siloed by vendor and driver, so will
>    cause no harm.

Right, this is just a restatement of the standard vendor line.

If the issue is purely about having generic bindings quite frankly it's
very hard to see how it could take much time or effort to handle the
generic bits for I2C, it's basically just the maximum bus frequency and
possibly also the various fast modes (though to a good approximation it
seems reasonable to just infer them from the bus frequency and then see
if we need any more).  One thing I frequently find is that people say
any sort of generic work is hard without explaining why, if there are
complex issues that's one thing but that's often not the case.

BTW, looking at the platform data again it seems like i2c_freq_mode it
seems very odd that it's driver specific?

> 5. I've already volunteered to move them over to the unified ones once
>    created.
> 6. These allow support for the driver to work with DT, at the moment
>    it does not.

> Personally, I think there is more to be gained by applying the
> (working) vendor specific bindings to the vendor specific driver until
> some more consolidated ones appear.

Again, vendors always make great promises about how they're going to
keep everything up to date...

--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBpn6AAoJEBus8iNuMP3dKeoP/RrR4e89lhefdhT9p9LijXqS
GFOPHvqWSkKvwNYqaJnyYAEaski/RaQQyYHOhxStK+Ir8zwjAHibIXVM+J9t3807
AfFb4LmOclyVEjN8V3lLP3DXdamk1htnf4dNhMHnvS6Zy7KEGBMyMv+r0xpZTPB2
J+aMtAoHZ+tZ8Bkik54E+6JIHVaU0ojppcTKgWfVu1e6RrBaVi2CErxHtDpwVrot
nRZ8QfYMttCJo9spjGPMx6SZ0PpDn5U6U2g7aIsZEmYjyVXEPb0oiON+FgOamrzd
teAQxWi/P1wWlWXDXMKNGxZgRVOUrZu9jpLgOUp9VT/r9XbTu3PdDHhPXdsEJ1fC
7pB6rIuOe7hIwGUIix9I3ocYgjG4O351B8hsxz6TqZXpWjSOXL4L5ocmom64LCRX
0S6ua/mnRpq+/3UCsqJAXNDgqcnf9xCwPgYcZSTlB2JkqtJnqf8scO0WJt8Q4Uc5
rDu33tDs9EmNjbjvungTWjGle3fDfD6Koh6woRF0Ngv/fm9G+Y4rNR3iyM9I5RTR
yLpCS+23X2XRQDwSwbHb2wKvCWAPj3uh85KqfMD/+0Jk1/NKR62Ipnv6z9vj2t3+
2f7AV3HOe/u47SvePQHs/hdzgm7bq8GtVI8ItrS+p7s+Fs2pAEh0qObNE1Rae891
lcPAI9GbHAzvRET5yLv9
=eCiZ
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--
