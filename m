Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab2FTTqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:46:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52785 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757953Ab2FTTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:46:13 -0400
Date: Wed, 20 Jun 2012 20:46:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org, swarren@wwwdotorg.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120620194609.GA4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <201206201924.09618.arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 07:24:09PM +0000, Arnd Bergmann wrote:

> 1. What is it that the new property can express that cannot already
> be expressed by using the phandle.

As well as being able to refer to the object from within the device tree
we also need to be able to tell what the object represents - we have a
bunch of regulators in an array under a node for a PMIC and we want to
know which regulator on the physical device each array entry corresponds
to.  Previously this was being done by parsing the phandle name but that
means we can't have more than one device with the same set of names.

> 2. Why is it called "regulator-compatible"? If it's similar to the
> "compatible" property, don't you have to have a binding for each
> possible string? If it's not related to the "compatible" property,
> why is it named in a similar way?

Yes, there are bindings defined already for all the relevant devices.
Elsewhere in the binding document you'll see a list of all the
regulators on the PMIC and the names by which the device tree binding
knows them.

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4ih1AAoJEBus8iNuMP3dmLQP/jsJbvranT6yL/NDD7aDYY3g
fb2cIt+LwfPk7bmF7vp+lPxVUzSXpndniYHcqHBP7QqG8lY77anCeDpC6ZXV8/Z6
gBwSJfGpqgNgWGDjjzqf7+GdML07iyupUj5T3E1O/sNfR3UxLP/7YjmhzBu1T96e
ETMBf4JiLRvfrR87LkAAQJdkGaeYAlPg4mITeQkmte+ctc/Ctgyt8jmZPstJXt1c
GaVJ3zu3QwCteN0xktHe5S9eMh/pxH/zO1dYyVEjn7mIbhV8hoawrkuGXdjUNxVM
Gow4ZDoU4ztQcHYn1TWv/fmV7l5g56KrvKyu9FqRrYrFhCs9hPL3wFpfhvrQsj+D
3Jd/lZV40WvTaGUh+SgjsHsfSY1+bTEHV4kEISpLUK/KGD1sdjGsvhVxt9XGjFzC
kwsTJIHqMs3fNk73rXTodelyD1D+BzsY+WMJZp5/Hj/JjXwBWDkki6031Iei6K3Q
JJlQsivn4ote2Ta55UEeeUkA/v1rq7F/MxcDMQWBgTyPiNWdohMFJ/O64HB/6FLg
gNV/mhDQ0kv0aiuFhkXNM1cqbCoiZQZ8VEDZd3lCUFBLefvw0MM7rZqGYESQsfQX
h62ykpyUA+YlMdP04GExGY16N1M+u+rF3zsXCeoeceZwC35ZomvgqMezmYi5bkD4
/qkWf04Zs3YwL0UVToZb
=zPom
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
