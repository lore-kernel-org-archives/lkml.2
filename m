Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2JWKs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:48:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33125 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2JWKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:48:54 -0400
Date: Tue, 23 Oct 2012 13:42:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <balbi@ti.com>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <damm@opensource.se>,
        Paul Mundt <lethal@linux-sh.org>, Benoit Cousson <b-cousson@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023104256.GB24820@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
 <508664CA.7000601@ti.com>
 <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
 <20121023100333.GA24418@arwen.pp.htv.fi>
 <20121023122312.56b23e1c@skate>
 <CACRpkdb+f44jw1vTYvJT0bnMOP8XQe8ztDUHiwtS2JHtPWAGXw@mail.gmail.com>
 <20121023102903.GA24820@arwen.pp.htv.fi>
 <CACRpkdZhUwMTg0suqbZiukN7Se6fzdYP3-0Dspm9WF6qZniNVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <CACRpkdZhUwMTg0suqbZiukN7Se6fzdYP3-0Dspm9WF6qZniNVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 12:45:33PM +0200, Linus Walleij wrote:
> On Tue, Oct 23, 2012 at 12:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Oct 23, 2012 at 12:29:28PM +0200, Linus Walleij wrote:
>=20
> >> So the biggest implementation of the notifier approach to resource
> >> handling is the SH clock thing:
> >> drivers/base/power/clock_ops.c
> >
> > that's different right ? It's just creating the list of clocks, device
> > drivers still have to call pm_clk_add().
> >
> > That's ok, I guess, otherwise all struct device would allocate memory
> > which hardly ever used (so far).
>=20
> Hm so I have had this idea of runtime PM core helping out
> with pins, so I could add something like
>=20
> pm_pins_fetch()
> pm_pins_default()
> pm_pins_idle()
> pm_pins_sleep()
>=20
> So if one is using the pin states defined in <linux/pinctrl/pinctrl-state=
=2Eh>
> then the PM core can help out in keeping track of the pins
> and states, and the driver will just tell the PM core what
> to do and when.
>=20
> Would this fit the bill for everyone's code consolidation needs?
> It would sure work for us...
>=20
> It however require that no custom states are used and that we
> keep to the state semantics I just happen to think is most
> common.

=46rom a quick read, it looks ok. I guess problems will only how up when
we actually end up with a silicon errata or something similar which
mandates that we change pin's state at a particular location. Not sure
if we have those yet.

--=20
balbi

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhnSwAAoJEIaOsuA1yqREyCcP/1vnOrhHdll/Qz/9kp/J+eY8
eNln33/N3Rv/30pfioJ6DU4KNUOO2YaxkDO88IesIm6nn1ZKExRh1ApKKgFQLQlJ
3vtlUniBFBQSG162Ur35R62fw/45DWHdbzqtbBeHaoxWGyfQ/zH5jQEA5TUrwnWm
wEq2rDTuMogpJzlh/p/h37VT6tsVp+RxFJYjRSOID+TY4A0KhzXzyhVdDBQAaXgT
WzZIS/IRarvV5SZO0zrCOzO97BLNChWtj0CUSLO++2IWOuUZSpXUjM9KwaombwvY
RB4EQ9noOhcXpGUXwj2o4I5LlKvcoLIuBfm3Ae72MqXNrmD4a94rkW7VBpYaCeG7
+NkroDf9IXSZq+Im7DkYcL162zVhTjQ/wK89ochG1MvFNjLLFcM2a0PQXjEse9tL
ZZYEJjqQS/OffbdRp41uuNpx+y+Lb4WyuXro5+SUZRx6Lr4sIvgmIoPLt98ACPYf
Cp4qQ1NWZp1WOMkdyEKXEkrEekCmwrQMa2YSew2X6124BOwPkls+LGCM/8Q0W/h/
bug64NJ+4JqteLEpqSgWCrWIknLC6ConhWm1kG45f3qxwQ6RKk6UwV2gjJr39cNQ
v43g3iHAq/OqbuO+08FvcCeQCumXXBzYxzUxvJdXbQfzQtiOUNmI1AYVnsDbjsCj
AI+nOyat0u34LfVj37Q5
=ezCD
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
