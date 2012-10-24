Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376Ab2JXRtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:49:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935263Ab2JXRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:49:13 -0400
Date: Wed, 24 Oct 2012 18:49:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Message-ID: <20121024174908.GI18814@opensource.wolfsonmicro.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
 <20121009082719.GC8237@opensource.wolfsonmicro.com>
 <BFABBC009FBA1C43B207B15FD485ABD922C22BE7@USW-MAIL1.synaptics-inc.local>
 <20121012051558.GK11726@opensource.wolfsonmicro.com>
 <508715CC.1000600@synaptics.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Content-Disposition: inline
In-Reply-To: <508715CC.1000600@synaptics.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 03:10:20PM -0700, Christopher Heiny wrote:
> On 10/11/2012 10:16 PM, Mark Brown wrote:
> >On Thu, Oct 11, 2012 at 03:56:22AM +0000, Christopher Heiny wrote:

> >Fix your mailer to word wrap within paragraphs.

> Sorry - I was on the road and had to use a web interface.  It looked
> OK during composition.  Is this better?

Yes, that's great - thanks.

> However, a general capability in SPI core is a fine idea for future
> work, once we get the RMI4 driver ironed out.  Can we agree to defer
> that for now?

Obviously there's no pressure to implement the framework feature,
however it shouldn't be implemented at the driver level.

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiCoMAAoJELSic+t+oim9aI8P/1cSUU9BVfNQIa5BS/St7tcf
RAJBurEzh76zG/S2HG5GupvjQ3oaAinO9GnBO5K8RG9Z67Qyz8PF40oyKCS6Lxiz
PDAxxsv3x6OKZQRh6SFspR4u6p6H6cyX8iY0kTrDzqEMZMFOUgkirPFgZF7laqHF
Q2kMME7U7L2+VJ13LlV1qRbnNy/fTazm7auWEqv3PONrk6W/Si/3p01SV7wEvLsu
YtAv4z5hvzC9fBqc2pvd2mlcQt3lJxs4uM33W6UGq0WnPJwYZtupJwEIGXZ+bUAV
3yWU/K8h2oA0KeFnQJPnOs9VCD0VB7siHS99AOl2BtLR0UflNglaKFaA7diBOfGR
/YfVP8Z2Bm6G0xypOEXzmFDDSrEAfFQvdU4rwKBDzI+hROYhwiIPN9NURIh2UR86
kS11iXvSFnP9ZO8PZyCgI4Mc/taVpUG83KMD9jL+xbS7W/3ddbmESwbhpF6aio8g
iorSFeGAh2pyXa6JSDi39PYBHWjDHBNGOaEbKr0zu1B9tWGoCa38aaMaoR7VVB5g
qfpq84WkI/ez7RdZcn+eJOlWIRkx4bkYcVxWmACf1k+cfk9uptddG2l0w8pBd/Qz
InLf2DIIgUoSE1CurOh1G6M0SjNKTt+FnMyI0uWsp/R2y4wW1aN1Pp+C7bkQ2Mov
ueLYfRc753ztWIX1kiIk
=aYQ3
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
