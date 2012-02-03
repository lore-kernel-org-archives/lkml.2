Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2BCLCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:02:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41021 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab2BCLCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:02:38 -0500
Date: Fri, 3 Feb 2012 11:02:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Balaji T K <balajitk@ti.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (regulator tree related)
Message-ID: <20120203110234.GC3151@opensource.wolfsonmicro.com>
References: <20120203161522.c079159878788e9ba7e7b242@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <20120203161522.c079159878788e9ba7e7b242@canb.auug.org.au>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2012 at 04:15:22PM +1100, Stephen Rothwell wrote:

> drivers/mfd/twl-core.c: In function 'add_children':
> drivers/mfd/twl-core.c:752:10: error: 'struct regulator_consumer_supply' has no member named 'dev'
> drivers/mfd/twl-core.c:753:10: error: 'struct regulator_consumer_supply' has no member named 'dev'
> drivers/mfd/twl-core.c:754:10: error: 'struct regulator_consumer_supply' has no member named 'dev'
> drivers/mfd/twl-core.c:800:10: error: 'struct regulator_consumer_supply' has no member named 'dev'

> Caused by commit 737f360d5bef ("regulator: Remove support for supplies
> specified by struct device").

For stuff like this where it's clear that there's an issue with the
side where the failure is noticed it's helpful to also let the people
working on the driver side know - it can make things work better with
timezones.  Unfortunately the TWL driver is both very interesting and
not really getting TLC so it's not a great example here but still.  I've
CCed a bunch of random people who show up in the commit log plus Samuel.

I'll fix up this up and carry a patch via the regulator tree.

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPK77EAAoJEBus8iNuMP3dIz4P/392EAGxZ2WziGwgQ+RnvhiG
gDiEQLaqvpc6UW6gT4IqxHHUqgY+gjh8x7svNb/BVG+EvbQoep5KORbCxP+5OIPJ
q2L4pTm7JaRWZcDTTvF2qOOiMF4XyyK6nr6yXxsl2FLIBMCU+RgbKugv7A4OA6LJ
XoRyAX4Jz+PUCzWgq7ndvNt43TolEuWwq4p3Sm2lSmDgspOUSZLOg1oAKHCu5fMb
ByCNg9+Omd8iQCyLVPDB2tZT5WSn0r0Ai+64GutoWFH7mZT7rM/PvbgqMHe1pVee
2lYi4ICH4xLfuwCHytT3hJCmI4lrR49PfKfWz7st4HFZG7XOVr2dhnUG5S+uqmfI
Ss60xRuw3I37cOagDTH740qPJ/+i7O53kYzA2W3r8S9wh7wn442xAmvg8tk1OGA5
shKu6nIm26SJsSxc3ZoJvdBEi4dHVtg84EeZEbNc17pCGxOkV0VK/fuUQ8A8CTeJ
VFV3bDTBxWh8YtikF9dnnXqUwiTUvK+movYI5dz3r03muIzhT6LIj3SmF0SA5IcM
JmL1NPVyK8v1BKkLbP4AjZSQqoqy+s+0igvwQMX/iVjmbGY8mLSMUcir8qgFQKex
pDx+H6P1+FA4CfMtzay/sIPX/KT7mzks0YXZtiCAhNpsJ1AyAJtaBpDmIAyFuJkA
fMONQNB+j/HyGZtMqBb5
=b8R5
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
