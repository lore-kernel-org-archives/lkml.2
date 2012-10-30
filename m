Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488Ab2J3Syf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:54:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37623 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001Ab2J3Syc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:54:32 -0400
Date: Tue, 30 Oct 2012 20:48:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030184828.GB4804@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
 <20121030155821.GU4511@opensource.wolfsonmicro.com>
 <20121030172513.GA3993@arwen.pp.htv.fi>
 <20121030182007.GA21851@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <20121030182007.GA21851@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 11:20:07AM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 30, 2012 at 07:25:13PM +0200, Felipe Balbi wrote:
> > On Tue, Oct 30, 2012 at 03:58:21PM +0000, Mark Brown wrote:
> > >=20
> > > But then this comes round to the mindless code that ought to be facto=
red
> > > out :)  Only the more interesting cases that do something unusual rea=
lly
> > > register here.
> >=20
> > fair enough. I see your point. Not saying I agree though, just that this
> > discussion has been flying for far too long, so feel free to provide
> > patches implementing what you're defending here ;-)
> >=20
> > Guess code will speak for itself. On way or another, we need OMAP keypad
> > driver working in mainline
>=20
> Are you saying that introducing pincrtl infrastructure actually _broke_
> the driver in mainline?

no dude, I'm saying we need pinctrl working for this driver because we
need to remove OMAP-specific MUX settings. One way or another, this has
to work.

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkCD8AAoJEIaOsuA1yqRExbwP/RsiJ0tZ4envXPJkAk9FusHr
gM3KATpzj8nsaedhnfQU0qA7X0adO6tA/QHJFva869xp071/PnoaGv+tsqiMb8Nv
7HZAA6p577k7zNdN+FjzNSgtLt0KQrkIt5DatbzXJxbhHhNhCqqlbvYzJ+IGD/Rw
lUy4feXwn5TRgPXNvSyLaj13Tg8zEYBGRFsrbLijAKHVQKcsAIvp9Si3dd2kod+R
4GrAxDsCBi6SB+4zHBDoW0kEZBubs5PRO44l3nzeumMMQWk8FfsRbzajd/GtiAdb
BDWLKr4p4EXjVeTVkbvvTHvH9QbhhWbqHUZINXeflkVTnugLHu7dHDzeBi4VpodX
d+JLA33ACaXG0CSGnq3znHGqYd7jCFPGh6lPLct5hFrsgZLcgj10aJUGdVdiKvCe
VNlQ6jAcjBJNuJUC3FiR+bTouxvOrSjHGkF2xjaT3fmsAquZZULC2GXpJbdaAZeB
e+fRsSl7oSVlUvh+Irzrht8tTiSPVQ8ZAEZgQ5IPaGWL6G8ynibJQ5hncTPtpzsH
dk+W4ge0xCf/Qvwe+RoYwSb5N1LU3wIhB/W5nyMNovEALhhNxozG51AJ6icULw5w
8P8jfgMKHUECBHc6BckU+f5TA+D2cqaFAQc+HuYn5JB9fetD91gsjSc79A/5ogTD
Ns2dQ8ziOK292Tbf0nNu
=Wytf
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
