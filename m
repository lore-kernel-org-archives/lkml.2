Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560Ab2KAOTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:19:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011Ab2KAOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:19:37 -0400
Date: Thu, 1 Nov 2012 14:19:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121101141935.GD4413@opensource.wolfsonmicro.com>
References: <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
 <20121030113407.GA24335@sirena.org.uk>
 <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
 <87obji8kta.fsf@deeprootsystems.com>
 <CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
 <20121101120713.GA4413@opensource.wolfsonmicro.com>
 <CACRpkdawAdbwackZeST4iDkFZx9-exhTVoUzAABaWr1G89tATg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <CACRpkdawAdbwackZeST4iDkFZx9-exhTVoUzAABaWr1G89tATg@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 01, 2012 at 03:01:28PM +0100, Linus Walleij wrote:
> On Thu, Nov 1, 2012 at 1:07 PM, Mark Brown
>=20
> > For the pin hogging I'd actually been thinking separately that we should
> > just have the device core do a devm_pinctrl_get_set_default() prior to
> > probing the device and store the result in the struct device.  That

> What if I retrieve this in the pinctrl subsystem using
> bus notifiers and then expose the struct pinctrl * to
> the clients by using pinctrl_get() and when you get
> such a handle in your probe() you know that the
> pinctrl subsystem has already fetched the handle and
> set it to "default" at that point?

I'm not sure I parse a problem from the above?

> I just worry whether there is a fringe case where the default
> state is not be be default-selected in probe(), the API
> semantics does not mandate that. But I think this is the case
> for all in-kernel drivers so we wouldn't be breaking anything
> by doing this right now. And platforms can just leave the
> "default" state undefined in that case.

Yes, that had been my thinking too though I'd really expect that the
platform ought to be able to think of something sensible to do by
default.

> Then what to do with sleep and idle is a question we need
> to handle next. Requiring PM domains for this is one
> approach, albeit a bit controversial.

Yup.  Notifiers are another option again I guess.  There's far fewer
drivers doing anything at all with that so it's a bit less urgent.

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkoTvAAoJELSic+t+oim9T3wQAJT2fTjcoqAXIen2dnrccrmJ
D6s1XbYfPoJdDLIivRMEXiYmzlKIutlEobY49P7qhfUnhfbv4cfE7nwi9k2V4xPR
qtEhYhyDtUgFkRvI6czUTbd3ZKzt9jUGIhJ4W5Y/545Z0z3m0Rld0EgG6Wh53oyg
GGBZgQA9kytWZwEYsT+wAjp6QCtsBIGp3zOTk1coEP3Sic+S32aRdsaYRvfUIIDN
F4pC07KbhngWrYYmmFG9k92NcLx3npZdDYLfrTXgFAP4HEOIMVRv4ItZ1Q8O+te7
S6VPvG0IthQDTx1jBWCVM5DwtbLW5EL+xALoYl/kiaz/LxaF/p2i9EwDqGsx0sQA
ixhbf+73jmqlotF7/89gCrxDNab6+leHZ7Nvtoe9BPl/jvMfNUdSJGFPlo2NO9KK
5u5ZgFqf5Bv79T8ynfFtw8Uj5BkvKcSUhHctkDzKkEaDhJxjgsk+K6xLNK7gjvUM
4EiLCr402HqIbWCRQoyIEi8KwetscSGnuuKG7gASwXrTlLo5+97kWnCGuhJTJSYQ
DVue1ifdgJxovlS6jaGWmRLYRkQvM33sX6BJhxoT6wRfLY8u6q7uEUdxNMOs8R2Y
hoSgz3BS/k0qFDIG2ujGJ74UQRRq0M6G7q7kziL4HIhI7IjuMAFXFLORMrW7igXF
wpHPrs85WBdYtGxdCYMf
=PUlE
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
