Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2LSROc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:14:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46451 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667Ab2LSRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:14:26 -0500
Date: Wed, 19 Dec 2012 17:14:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        khali@linux-fr.org, ben-linux@fluff.org,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        grundler@chromium.org, naveen@chromium.org
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration
 implementation
Message-ID: <20121219171423.GW4985@opensource.wolfsonmicro.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
 <20121219123201.B636A3E0AD7@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NHfequSh1hmJPP0s"
Content-Disposition: inline
In-Reply-To: <20121219123201.B636A3E0AD7@localhost>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NHfequSh1hmJPP0s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 12:32:01PM +0000, Grant Likely wrote:

> I'm not convinced on the design of this protocol. It won't scale beyond
> 2 bus masters and it seems very specific to the design of a specific
> piece of hardware. I don't think it is mature enough to bake into the

I ought to point out that the original patch would've baked this into
the Samsung I2C driver but I asked for it to be split out as it's
nothing to do with the controller really and I'm sure I've seen it
before.

--NHfequSh1hmJPP0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0fXoAAoJELSic+t+oim9uekP/1gKDaELx3ooIe4UOtlMYrZC
54DUlf2wnOTNzOnBRWjTk5wmNa+gxQdeCBWWeCVTB7Gbk1SDFU6KkSSl5eek1OXe
D4wvHV5CQSvJy6A3l+26GPhNWE/fCq6FgMrEYDJqqZKT9q+F5ls4sBD0GLT5a6kA
DI8q2eByPt/BctDmoGgtYlFtSgwndG0tUND7/wm7BG4B9KpSPmAOsGQA46Pludh2
EQI89v0gcOdEIGvc+bo0RsZ1ROKYVlXVG1G28zZIt7r80PiVwvqkLtMLR2Yo88Wb
Z+W0nWPQZ6qKt3eRkTRJUEjKHKsGdrlOokCxZmsZmRVP2o44vOHvlolA5NaaYJGJ
b64FWDdmIy8YKWD2LkFNwj14YspWPUu982AMJUu5jBIF6MCifaK3oeG30/zIySsT
dheu+To2FysILsGIx7Rdooo3uZkfiT+TB+11JRFBqblnELNF7XM3vg3NXx1WYpQO
lPJfRGzsaQY3665WHdvmOzL78f1DUs7LaeTXv8wxpKrZkX+r90jH295/lDZyrtSd
r+wLoSkrn9Z3pmraQYra6e4A6oRUD07/AnZm+NwkMeY4rHT6cY2NyQV0wbhg6qH5
pQWugWsRBZBNr5kYEy09y6sbb8gA6FIOfxgPuTvunndZ9m7LPl/yds73Y/h5She7
FUbvxQYUr7twQthN5kdR
=cKLv
-----END PGP SIGNATURE-----

--NHfequSh1hmJPP0s--
