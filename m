Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab2HWLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:06:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757533Ab2HWLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:06:50 -0400
Date: Thu, 23 Aug 2012 12:06:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>, Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "paul.liu@linaro.org" <paul.liu@linaro.org>
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120823110647.GU7995@opensource.wolfsonmicro.com>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
 <20120822160241.GR7995@opensource.wolfsonmicro.com>
 <20120823072629.GG10057@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zfUJHOO+0QrREfab"
Content-Disposition: inline
In-Reply-To: <20120823072629.GG10057@shlinux2.ap.freescale.net>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zfUJHOO+0QrREfab
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 23, 2012 at 03:26:30PM +0800, Dong Aisheng wrote:
> On Thu, Aug 23, 2012 at 12:02:41AM +0800, Mark Brown wrote:

> > It'd be good to provide a way of retrieving the regmap so that drivers
> > for subsystems with generic regmap code could use the framework features
> > (regulator is one example that I just mentioned in my other mail).

> Do you mean something like:
> regmap = syscon_regmap_dev_lookup(np, "fsl,anatop");
> regmap_write(regmap, reg, val);

> Then drivers can use generic regmap framework features rather than depend
> on what imx-syscon implemented, is that correct?

Yes, this is mainly for cases where the subsystem has helper functions
that can work with regmap.

--zfUJHOO+0QrREfab
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNg7AAAoJEFJkBDiqVpZ4MMEP/AwOzMlpcS8qIHrRB4k/ELDF
fBzkP3bWtdVqwCyJjc4JU/oEz/g8o15vXwB+VIsGwf0e5Htk7X7U5eza78eXu/V4
2qah5HMSJSi+gu+HjM24665O5wAwr6VqbokXaDtB8VdlXVxICh7Bi7Cib/rr8riI
8FFf6TyvRnoHdF7WswXDSdAN84aVW2Vk6vX8egzZHIh/MIgmBdUd3xuk7/sm+1M+
O/1SejKVo54cygeSg/L73be4evknYs/r0LwGNyHuIc5mKZ5VXqzKSeA2mkvkZAKS
pb9LgsV/6J09BRI0i8xknl5rCbZ56U7C0GYQnwkHTWqsKuHZ8CzZ/k7GZ/1Evq99
0jFe/n6ioKMd+AnN85EhNtpTmO5Z8kJseEyBIFQhrLMf1NX2dAmUKR3lo/YhA0n0
eUdf5BthODvrtiRkizUXhXz1cZ8PfNzWmQLnPX8aBM7V0lTZHA7XJ1E6j8wunW8w
OyRE117Y2+1lsA2R0PUh5/Xl8/VDNWS2gNG7ZHDbxJUDbw2d7dE06J8ibcuLxAN3
Lt5nncusVy8uuvj/qHS7Jnra62qNPP7MwFbG6Y/s6pzBgmfyjQIbLTLLv6F4NRyI
B5t4qu1avPP+MHbnXM/OVZCNxG7W6DgGdO7vK/PYRmnm8QvCGE1SvGBu+3I9nOR4
GpLFT0IPp60aB+eOnRsw
=IvBW
-----END PGP SIGNATURE-----

--zfUJHOO+0QrREfab--
