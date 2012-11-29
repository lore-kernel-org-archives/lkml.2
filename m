Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2K2PPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:15:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57607 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab2K2PPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:15:46 -0500
Date: Thu, 29 Nov 2012 15:15:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121129151543.GK32691@opensource.wolfsonmicro.com>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
 <20121128070332.GC23378@core.coreip.homeip.net>
 <20121128085731.GH2013@gmail.com>
 <20121128163105.GA28698@sirena.org.uk>
 <20121129100808.GW2013@gmail.com>
 <20121129112058.GH32691@opensource.wolfsonmicro.com>
 <20121129120000.GJ2013@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg/E/yN4pR4or5qL"
Content-Disposition: inline
In-Reply-To: <20121129120000.GJ2013@gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg/E/yN4pR4or5qL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 29, 2012 at 12:00:00PM +0000, Lee Jones wrote:
> On Thu, 29 Nov 2012, Mark Brown wrote:

> > Right, which is why this mostly works, but it's still better to provide
> > an actual compatible string which we can be 100% certain will avoid
> > conflicts.  This is very low cost when one is already defining DT
> > bindings.

> I know that it's an easy thing to do, but I'm more worried about
> what would happen if the an I2C device is registered using the
> current way (stripping the compatible string and using it as a
> client look-up) and we also provide a compatible entry in the
> driver itself. Do you know if there is any danger of duplicate
> registration or suchlike?

That's totally fine, we try first with compatible properties and only
look for the fallback if there aren't any.

> > > Hence, there should be no need to have a compatible string in any i2c
> > > driver registration information.

> > We're getting away with it at present (and frankly nobody's going to
> > build in two different drivers for a chip of the same name for practical
> > systems anyway).

> Right. In the same way as we're getting away with it when we
> register a platform_device using the register/add routines.

Those are all completely Linux-defined of course which helps as well.

--bg/E/yN4pR4or5qL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQt3wXAAoJELSic+t+oim9B7AP/3iH/RwYN3t5B/y96DrQw3/r
f9JERuj8k7lGtMyH6VrnyLdMQxMOoVfnjQcM5y9/UusgbmZ+mG2Qd2Wgsy0hIXgU
Rr1YZrdIqPTfVJbo/YwsULhaJSv4grt9zLNJWcAc8kbhWkRjE80PbWGR1uEnoiIX
z9V2AmJ5Eh7W6DtT26toyZBV+0GUNvOVTn4cYFm+rlr/OeV3DLR7hEQmPsbyYori
ExcEDCcnm+ww3F6DB7Df1OdrpmQlFAhQdnIPBLIYKUAm55pt6U9qPHCNjsmT/DVQ
uaO2Z3AlyFjCbMwhCJ6ntiRSkyq2gra3BCswDhTy6ujC6aC6nSRhRxpS43Cu1L0c
CHXMY+xDuEvyRM7vibeLWjdMidRFyuUXkVDkYZM65PGYqOCOTMgcBrJ11kpBPGah
wUVYhYVc9meN0vyYy6WVUyLUz5wNX5FsSGY4ST6uS6eJmOepn5WleB4CZJ8zseyZ
J9sV/Stw2qyFI50jw5mCHu7LMN8IM4qViTqG1lQYutlHyupE29AR5nBGS0j8C28K
F31bXmwFD5CL81SugpN2X9u33dq1bzMI1+aguVvNYnmi6bFveUuS/XPyLrRIIsVy
mgw2Z7cZs9xTBhpEI8LoEQf2Me6gF2SB6RLprBbhdTJ49aRaFOAvbBUb95wnffDl
cKHryLaDdJwf47/i28FK
=SVo4
-----END PGP SIGNATURE-----

--bg/E/yN4pR4or5qL--
