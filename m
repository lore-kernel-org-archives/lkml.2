Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2GPMgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:36:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42680 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2GPMgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:36:09 -0400
Date: Mon, 16 Jul 2012 14:35:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120716123550.GE17435@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
 <20120712131231.GH2194@pengutronix.de>
 <CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com>
 <20120716101706.GB17435@pengutronix.de>
 <CACRpkdY626iYATorphAvg7cQxD2ufysBvXdt3Z644zEuW0wS=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <CACRpkdY626iYATorphAvg7cQxD2ufysBvXdt3Z644zEuW0wS=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 01:37:13PM +0200, Linus Walleij wrote:
> On Mon, Jul 16, 2012 at 12:17 PM, Wolfram Sang <w.sang@pengutronix.de> wr=
ote:
>=20
> >> And about the perpetual nature of device tree bindings it
> >> appears to me that the modus operandi right now is to not
> >> regard any of these as written in stone until they are removed
> >> from the kernel tree. We have plenty of drivers patching
> >> trees and drivers in one for the moment.
> >
> > I don't get this one. Yes, they are of perpetual nature, so how could we
> > remove them from the kernel tree?
>=20
> What I meant was that at the point when arch/arm/boot/dts/*
> is (if ever) removed from the kernel tree and into its own git, so that
> the standardization of bindings is decoupled from the Linux kernel
> tree, from that point it is no longer possible to alter the bindings
> and the code in sync, so at that point the bindings need to be
> frozen and all subsequent work will need to gear down and
> work on bindings before deployment.

Uhm, I seem to have missed that bindings are deemed more "flexible" as
long as they are coupled to in-kernel dts files? Is that discussed
somewhere? I do wonder about it...

>=20
> That said, this does not at all solve the problem of already-deployed
> device trees using old bindings...

=2E.. exactly because of this. I don't think it is possible to really drop
a binding. Only to mark them deprecated. Which can really be messy in
drivers.

> > What I am afraid of is: tentative solutions tend to stay, because the
> > need for a proper solution is reduced. Yet, finding proper generic
> > bindings might take some time which doesn't meet the high pressure
> > around DT at the moment.
>=20
> I'm +1 on this. But I have learned that I have had to strike a
> compromise with people who want to forge ahead. They see things
> in the other way: perpetual committee discussions and no code
> nor device trees being deployed... :-)

I do know both sides. I easily agree that we have to find a balance
somewhere to meet both interests. Though, currently my impressions from
maintaining I2C are:

a) it is not balanced, but too far on the "let's deploy stuff" side
b) developers have a tendency to simply map platform_data to bindings
   and are surprised when told this is often not possible

which adds burden to the maintainers (who sometimes might not even be
familiar with devicetree because they are not focused on embedded). And
I worry about bindings of unmaintained subsystems.

So, I guess, what I am basically hoping for is less pace and a wider
acceptance that bindings can be really non-trivial.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAECqYACgkQD27XaX1/VRuJWgCeL87xeALRomphhoiGkjSyvlMx
xYAAniVyl85W5gF7YhY77oPtx+BxI9Hy
=UiNt
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
