Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab2J3OyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:54:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40883 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab2J3OyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:54:24 -0400
Date: Tue, 30 Oct 2012 14:54:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030145420.GQ4511@opensource.wolfsonmicro.com>
References: <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <CACRpkdZysB2mxj5wZfE0N+iwTE-_AXbOV0bKRP5kSo=1hieKGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y9o+fgG4MNl0mnzl"
Content-Disposition: inline
In-Reply-To: <CACRpkdZysB2mxj5wZfE0N+iwTE-_AXbOV0bKRP5kSo=1hieKGg@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y9o+fgG4MNl0mnzl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 03:16:02PM +0100, Linus Walleij wrote:
> On Tue, Oct 30, 2012 at 3:07 PM, Mark Brown

> > Essentially all the patches I'm seeing adding pinctrl are totally
> > mindless, most of them are just doing the initial setup on boot and not
> > doing any active management at runtime at all.

> I concludes in some other mails that all Ux500 drivers
> will need to handle atleast two states (default and sleep)
> and some a third state (idle).

Right, that's the other common option and obviously it's just an
extension of the simple hogs which maps very nicely onto the existing PM
states for devices.

> And this is what we're doing in our patches.

> Arguably it can all be pushed to power domains, but that
> will as said mandate all affected systems to implement
> power domains, and effectively moving code from
> drivers/* to arch/arm/* in our case atleast.

As soon as they start adding clock support and so on, yes.  Obviously if
they don't want to use any of the features that are offloaded like this
then they could happily ignore it.

--Y9o+fgG4MNl0mnzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj+oWAAoJELSic+t+oim91XQP/3/AoT73wqFhoXISasrhp7xm
671tREdtuwwtdcqVRCIMmn+xrnHcYyJN15OTOYlBFFzFGlTv8DSDmffqvYY1U3UQ
psyzgBjbO0JCF3KNQKugktbYb6M428ryTQLFr6djK2PODF4as2uM26gPZf/TZs5y
EnH/q7XWzEwLey19MNAhUBxCEU9nif66NQ0vTV1WtU94zjZ8Omt55a3Uoi4K9Nvv
Lwf94hDTUfe2XDXd4sDtiyVR8JleGOWVWzf9oLm1asfgJjpgK14PtvE5p7CSQXSH
+zFjRlJWg5QYvM7RDrMP6fmeokWlijEdNA1gLHSZB6UkBljpl9E8JppvLj9xsZEU
ZlD1hBD9EqFXPJaYbIQ1ySS5EHYeAVBDGUloQVtBw/Ey86ERwwli/Vz3LwYOeht9
h7qqZC3IWxxiNl0eu2u1ZDdmpSQOlXLcrFwolIgLvrdr5nqU5egPUda0v4TQBuUN
1HfQt+E5pHZIY+6Sr+Mwml0fPxc5SL0ukdSi0GmTpStsqCEyLFkFS5OO+Xa3lUXG
IHazQYi38WElveranQAh9VEMM2Tu0UeF/R+cZw0phOgyCe5+AUdMSCK+IHCE0uXd
mhmTAWYxhDRHcZFvMwaZ4UDOcMcxOAInAYdT2kiJ4mtErWC5/+CrrBsY6/uYMNm5
6r/pqt8yVfhFow5sxoJC
=P/FU
-----END PGP SIGNATURE-----

--Y9o+fgG4MNl0mnzl--
