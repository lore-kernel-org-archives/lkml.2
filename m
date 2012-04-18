Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2DRKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:45:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37973 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab2DRKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:45:48 -0400
Date: Wed, 18 Apr 2012 11:45:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Roland Stigge <stigge@antcom.de>,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, marek.vasut@gmail.com, devel@driverdev.osuosl.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 0/8] Second patchset for LPC32xx device tree conversion
Message-ID: <20120418104543.GH3021@opensource.wolfsonmicro.com>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <20120417205001.GH6498@mwanda>
 <201204180806.16848.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qM81t570OJUP5TU/"
Content-Disposition: inline
In-Reply-To: <201204180806.16848.arnd@arndb.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qM81t570OJUP5TU/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2012 at 08:06:16AM +0000, Arnd Bergmann wrote:
> On Tuesday 17 April 2012, Dan Carpenter wrote:

> > This probably applies fine (the previous version did a couple days
> > ago), but it's always best to submit patches against linux-next.
> > The 3.4 kernel is in -rc already so this is 3.5 material.

> I disagree. The patches won't get applied on -next, they get applied
> on an -rc release, so they should be submitted against that version
> as well. I agree that it makes sense to test patches against -next
> when there is reason to believe there might be conflicts, but it's
> not mandatory. When you know about conflicts against other patches
> that are already in -next, I suggest listing them in the cover=20
> letter (the patch 0/x) and suggest a resolution.

Dan's advice is generally sensible for most subsystems - it's not so
much that you should submit against -next itself but rather that you
should be checking what you're submitting against the latest versions of
the subsystems to make sure that you're up to date with the latest APIs
and best practices.  -next is (or should be) a good proxy for this.

If you know the relevant subsystem and driver are pretty stable then
it's generally not going to be an issue to just use the -rcs but there's
enough areas where there's rapid development of one form or another it's
likely to save you at least one round trip of "that's nice but needs
some updates because it won't apply/won't build/isn't using this new
feature we want to convert everyone to" that it's a good default to
check with -next first.

--qM81t570OJUP5TU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjptQAAoJEBus8iNuMP3dJZ4P/iY16xk0BF5TE8v30mak6yNb
z+aj2veBWNfWrLTsIeYbyvkgMBkBmPcbCjAZaPHGFNjd32vtakteiPbScetuG62J
qZQSzUmjZjrKyAQypA0a6pOrGaKaLkSktRqXhNKty9nGg9v8dsXkaylr76SYqCDr
yCHxO2qxgV60OCBe3GQ6CVcR+v8rAiTYrHZACAnB/of1Arf4dsddmfSKE+rfnqAI
mwWlfgdXyeWoZUogG7DVJ7IQhMlLmeyvXXb+NG0qHiR0GpYFihEn30/kWgU08+Z3
ijgO4fXuwRYg7dYctU1JvtKlCEq1ojqAmb4QFcIZzv5za0JudspoeZ0bkJwyuc7P
0n6K6u0nX1uezAFmVR+foP0GQBBuel9j7trcMcU2akxgFdUV5pJ+CFCBnnWbGJrH
MRJOkF5I/2edglA9t8w3M8Eb0NV7Oymcdt8+ianZ971C0cGuENpgJ1uUpXhw3fVw
avZi1w7P2RJrihJ/6AhiTW31cDsd9SYFoUQUoLA/plPQ2Zn3vjF26h9jppSPVGPm
bZj03SI9E3vL9zgFaPOr5+PoBgzbaE23K3Qtf8F8P0EXscspKQYjltzc7l5BxIcy
GWaxAhaf+Hfy3tQgAJmDXyxXWxWPeyc0idRdnE52q31DeAQVcuqKYyWa74BKj5p6
oZVUdwYxvTjst4UKLlRT
=Gj5B
-----END PGP SIGNATURE-----

--qM81t570OJUP5TU/--
