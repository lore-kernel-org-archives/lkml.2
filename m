Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab2KBS0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:26:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52844 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934474Ab2KBS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:26:36 -0400
Date: Fri, 2 Nov 2012 18:26:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121102182632.GF4413@opensource.wolfsonmicro.com>
References: <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
 <20121030155821.GU4511@opensource.wolfsonmicro.com>
 <20121030172513.GA3993@arwen.pp.htv.fi>
 <20121030183704.GX4511@opensource.wolfsonmicro.com>
 <CACRpkdac=ztY0vXQ8Mu6H8fiAO4aFSSF-A6O1Q==zKOKEsJegw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZsxMXj7gRnSZQ7B8"
Content-Disposition: inline
In-Reply-To: <CACRpkdac=ztY0vXQ8Mu6H8fiAO4aFSSF-A6O1Q==zKOKEsJegw@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZsxMXj7gRnSZQ7B8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 10:51:11PM +0100, Linus Walleij wrote:
> On Tue, Oct 30, 2012 at 7:37 PM, Mark Brown

> > More seriously the amount of time we seem to have been spending recently
> > on changes which end up requiring us to go through essentially every
> > driver and add code to them (often several times) doesn't seem like
> > we're doing a good job here.

> If this is your main concern you should be made aware that there
> are people out there planning to supplant the existing DT probe paths
> that are now being added to each and every ARM-related driver
> with an ACPI probe path as ARM servers come into the picture.

That's different as we're adding support for a new external interface
which will need per device configuration parsing rather than
reorganising things within the kernel; I'd expect it won't supplant DT
but rather sit alongside it as it's more a requirement for the server
market than for the embedded market.

--ZsxMXj7gRnSZQ7B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQlBBPAAoJELSic+t+oim95a8P/2gQNhkpjfeKtjLN+b7VjGx3
hS8eHcBUX37fs0Av+wz2BM+d6ySD7tBKsmw6No0KQvZW04JsO7KApQRSVJF+RU4k
HJfxHj1nse6FNTYwmMlkL6WZcyC1EXMgje4i0jHkbOambdO4pQn4q/sILkvsWgun
wBeTRDxViHVDAy6lNaHv79RId24cCsyUMPXpdj8PQ9Ci0jO0p6i2hxvHBMkwbMP1
RIIuGEEt/TWEQc2dq/FkXgazhWEr7KQcb8MyOeE26cRql23DGlRhxhmjAV3e+6HM
3sAPO0uBT+TPke5V+GOJXQLK7XoWW9zHoHobbRzWhwAOdm03KU7DO3B39/VvmJNl
4nWPtKWQc0QSA2rfCmBtAfLtyrSMDmlFPHFn41a/oHt82VZR7+JE9UPPi+bGusBo
tnnv6Gco+/FIVDvmyWg/6lj0CMTb7nLhQ2TOjYVbsIhI1hZ4g0imWDW/pvlX4MEe
Ea3+tFscm3bCQXI7mZSrgCbCRhoH8JXgcEKDYkBPciTYg5fSXP1FPuNHmhI2O8Jk
t43LkaZlxF+y0Wsq3/84Vsxt8djl88m4GMlt3ueNNPfyAcjid2UN9uw/kQ+H8lw8
G+Y8Y3Nk8GBPwh0OKAbl7P6IM1plcV3tXSS6xHKkOFnyAn1zMpBgNq6sCyBjZ66U
bP0aYlue/RpPa91nWU4L
=qFjt
-----END PGP SIGNATURE-----

--ZsxMXj7gRnSZQ7B8--
