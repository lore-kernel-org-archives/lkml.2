Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2JWKfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:35:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39198 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab2JWKfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:35:05 -0400
Date: Tue, 23 Oct 2012 13:29:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <damm@opensource.se>,
        Paul Mundt <lethal@linux-sh.org>, <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023102903.GA24820@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
 <508664CA.7000601@ti.com>
 <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
 <20121023100333.GA24418@arwen.pp.htv.fi>
 <20121023122312.56b23e1c@skate>
 <CACRpkdb+f44jw1vTYvJT0bnMOP8XQe8ztDUHiwtS2JHtPWAGXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <CACRpkdb+f44jw1vTYvJT0bnMOP8XQe8ztDUHiwtS2JHtPWAGXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 12:29:28PM +0200, Linus Walleij wrote:
> On Tue, Oct 23, 2012 at 12:23 PM, Thomas Petazzoni
> <thomas.petazzoni@free-electrons.com> wrote:
> >
> > On Tue, 23 Oct 2012 13:03:33 +0300, Felipe Balbi wrote:
> >
> >> > But it appears that shmobile prefer to get all resources using
> >> > bus notifiers.
> >> >
> >> > So we need to form some kind of consensus ... or live with
> >> > the fact that different systems do it different ways. Which will
> >> > explode the day we need to use a driver on two systems,
> >> > each using the other approach :-)
> >>
> >> I much prefer having drivers explicitly manage all their resources,
> >> which would mean that pinctrl calls need to be done on probe() and, if
> >> necessary, during suspend()/resume().
> >>
> >> Using bus notifiers for that is quite a hack IMHO.
> >
> > Agreed. Just like drivers do their ioremap, request_irq and others,
> > they should also request their pin resources using the pinctrl API.
> > Hiding this behind a bus notifier is not nice.
>=20
> So the biggest implementation of the notifier approach to resource
> handling is the SH clock thing:
> drivers/base/power/clock_ops.c

that's different right ? It's just creating the list of clocks, device
drivers still have to call pm_clk_add().

That's ok, I guess, otherwise all struct device would allocate memory
which hardly ever used (so far).

--=20
balbi

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhnFvAAoJEIaOsuA1yqREgMsQAJNJcFLikO8MiSiiIpbOyOUf
IOwqJUSqAx8BGrPQuUYeFWM6INwmmfyvkxvK3/G0gRzVD59hZGq5evMqgWDl/GDg
TV47q7piCJUC9BadnoAB3q+SmMdSdn87QwID9tWJu1hbdxn2Nd3FofoPxTRjrpuK
5d26eAHjhXcGP8DAww0AVlnokzepsODHoV9uN3D8UtLqDwQ0+ccLUFhdBd3uVSSV
5GUkECwT7xvSDkOwyFoJXmMYe3e20mEVRjjs9g0I6Bjb/n7lF2Lw6otOv5mpFoKv
Lp+gJtvLxJebCGlznMAVWEHNml9tAnTaY0GEpFzpwo2X73tM5cfRRdtuYeLRj1KO
75a8u459UmAlJKCFDdux1TRKnxjAxZB46vbTCCjjERVAzvQn2kdnVmoH7PbhRkK8
G+EK/FGpmsI8iyX7Qad0/LzW4XULfzEjUpyZub5sbwW5oRJQFNi9FP6cwoh/YACv
vWHJpgI/fWT75jzH8ZtnkdHebIcX7Gjsk08tGTTmfv2jFA6WKtztxe5LVFqCuL3x
eqRZJUtQsepYahRhls3l6m/SbBtuvjvcuBtoDOqSu2owE7BPt1Aj41QKdqfnI9AI
R9pZePWEg8/eTDa7cJ5AgdVODiniMEaaOudASPwYu659EmK3r9TC4FRocAkeMkJh
NFvLsVmrbTU7qacqueww
=uAgI
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
