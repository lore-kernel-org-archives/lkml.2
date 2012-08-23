Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2HWLRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:17:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47953 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2HWLRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:17:44 -0400
Date: Thu, 23 Aug 2012 12:17:41 +0100
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
Subject: Re: [PATCH 4/7] regulator: anatop-regulator: convert to use
 imx-syscon to access anatop register
Message-ID: <20120823111741.GX7995@opensource.wolfsonmicro.com>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-5-git-send-email-b29396@freescale.com>
 <20120822155953.GQ7995@opensource.wolfsonmicro.com>
 <20120823071503.GF10057@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vZbAFtxic7ONUJfi"
Content-Disposition: inline
In-Reply-To: <20120823071503.GF10057@shlinux2.ap.freescale.net>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vZbAFtxic7ONUJfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 23, 2012 at 03:15:04PM +0800, Dong Aisheng wrote:
> On Wed, Aug 22, 2012 at 11:59:53PM +0800, Mark Brown wrote:

> > With the conversion to regmap it'd also be good to convert the driver to
> > use the regmap helper functions for enable and voltage operations if
> > possible.

> The anatop-regulator driver only implements set_voltage_sel/get_voltage_sel
> which i have already converted, what do you mean others like
> 'for enable and voltage operations' i should also convert?

Those operations should ideally be converted to use the generic regmap
implementation now the device uses regmap - regmap_get_voltage_sel_regmap
and so on.

--vZbAFtxic7ONUJfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNhFOAAoJEFJkBDiqVpZ4FMUQAJqRf050UwEgd+lOkw7TQESB
JIlAGwap4ik235uGuM96R++oRCcOKOKx2bc+fM4bixKUH8FDAUBDEc+v9YPo4ACI
D9Trr1w0fntF5wz7ZjOUxM/MEPohqPOlZ6BmKYc+EhY4EM70qJyzi+PNX4nkEG/P
kIgYu8O00MbzwEtQshu/nFYCPzIKScpvThZUq3C8AWy1pX6i9MEblD+cjCx88iuZ
CPA+k/dGgtBDhxPr1z+Iax59ze+q4l3oLpX0tXC8mBrymY8Tlz89ZXmtroa2ZH3l
D868iChT0TX/l2JgIku+XgYOCzRX5cpW3jScU1bIT6Ly75ryPM50hWUQ70WydZR/
/qsHobyWlgVQfNnHFddlZPr8lD1z9WmKX8Drx7uE71zPsAtreZZ+h+Jd79vxFMZo
i87gOGHWW2F8Fkx6d7QrRNEsF1cjbciqFZAqpWCi2dfBoD/Mh3pjVTx4eIedSUKv
sxkgXt8oNzN/XarlUaNHv7Pb32OIcLlImmCjmGxdIrtZ1Ce1JomYM61FshMVr6yf
Mb9i/XZ3qTvXwFV6yNMSVu6YlTHczSbTUO9/OSh8XETKd1dFZm2iGCrOCogLYw/3
6Q09xhis1a4y5T0SRP5bfuKdSentio15xjuKdrdJb+/m8V3/d+lgHUO3oshAlgQX
k2SaZUiSwoBspqn9AwZQ
=ihQw
-----END PGP SIGNATURE-----

--vZbAFtxic7ONUJfi--
