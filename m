Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2J3ShJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:37:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33212 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab2J3ShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:07 -0400
Date: Tue, 30 Oct 2012 18:37:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030183704.GX4511@opensource.wolfsonmicro.com>
References: <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
 <20121030155821.GU4511@opensource.wolfsonmicro.com>
 <20121030172513.GA3993@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DMefDzZywwCHZelG"
Content-Disposition: inline
In-Reply-To: <20121030172513.GA3993@arwen.pp.htv.fi>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DMefDzZywwCHZelG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 07:25:13PM +0200, Felipe Balbi wrote:
> On Tue, Oct 30, 2012 at 03:58:21PM +0000, Mark Brown wrote:

> > But then this comes round to the mindless code that ought to be factored
> > out :)  Only the more interesting cases that do something unusual really
> > register here.

> fair enough. I see your point. Not saying I agree though, just that this
> discussion has been flying for far too long, so feel free to provide
> patches implementing what you're defending here ;-)

> Guess code will speak for itself. On way or another, we need OMAP keypad
> driver working in mainline and I don't think your arguments are strong
> enough to keep $SUBJECT from being merged, unless you can provide
> something stable/tested for v3.8 merge window.

Ship me an OMAP5 system and I might see what I can do :)

More seriously the amount of time we seem to have been spending recently
on changes which end up requiring us to go through essentially every
driver and add code to them (often several times) doesn't seem like
we're doing a good job here.  pinctrl is really noticable because it's
new but it's not the only thing.  As a subsystem maintainer this code
just makes me want to add new subsystem features to pull the code out of
drivers but obviously that's not something that should be being done at
the subsystem level.

--DMefDzZywwCHZelG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkB43AAoJELSic+t+oim9I0wP/1rfBcXfK+YljZUr1hkeCm28
8C32AJqxiOv6udgo4yLnsJmfJkCXiyrLrg5Xl3mfXL/Jl+CQVYUM3GaqatPsqA08
0Olfa5KM+Ftsfvb91lxjvqYvYHzmkFBUY4s3Kk5Xtu0ltEeTy9Dxvzb7Sh8Pj+/m
cwBBqwf+milN3u84ZxHvgpLshzq+prsUMq0ym7gnr8+7VeDooSM+uao5uk/hSblw
FloanO5OkNk/FSHfc9eAEDaJVHHrxM88bWwTNkR3IvFwdB8WFVwbHpuXHlg3PhLy
3hoiDDW8yTJxXwYy9ld8jpTg4O36kSTF5+nHYkWTAm0UUocdAEy0z4/cNnj/Wjqp
v20zhskCYp6O1TWa5Ws34fgeifVgOKTFEYuURox1g7CXJCbnO7coQvY4GAbV5nqQ
9GCQTIkLomOocctANrABGNEAMcNmU3E5JEhDaPMZhKRHwuMB0X1msaE+E/knwRUi
DX3XeV70DaiAqBKyVfmKQknzgE9qbyOSuEWzIyVvMFPQw8xYDJhUKxKeMOK2U3uf
0pKEamahZbQ6heUuyz5K6i6rUu+1zXkx3jqpVJ/DKpSM6keanNWzph0pvbT5RQX2
ubbVGu5yOe8wZfOWfmqlAK3cztUxMBw/raCM78BMV0CbNoA2eAXoJRrUr5bCHzmZ
Ea9qpZRWusegfByl1USM
=V4+A
-----END PGP SIGNATURE-----

--DMefDzZywwCHZelG--
