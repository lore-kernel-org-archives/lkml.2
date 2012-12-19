Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2LSNBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:01:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54531 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2LSNBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:01:34 -0500
Date: Wed, 19 Dec 2012 15:01:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Luciano Coelho <coelho@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <r.sricharan@ti.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219130128.GC17993@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
 <20121219103206.GQ4985@opensource.wolfsonmicro.com>
 <1355913954.5273.21.camel@cumari.coelho.fi>
 <50D19D54.2000307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <50D19D54.2000307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

+Sricharan who commited that

On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
> On 12/19/2012 11:45 AM, Luciano Coelho wrote:
> >> Well, we still haven't got the foggiest idea what the actual problem is
> >> beyond that it's probably related to the 32kHz clock in some way (unle=
ss
> >> it was one of the other reverts that coincidentally made a difference,
> >> but we don't know what they were) so it's unlikely that just randomly
> >> implementing clock support is going to fix anything immediately here.
> >=20
> > This is exactly what I had to revert (as I mentioned in the other email,
> > I had to revert the other patches otherwise compilation would break):
> >=20
> > 0e8e5c34 "regulator: twl: Remove references to 32kHz clock from DT bind=
ings"
> > e76ab829 "regulator: twl: Remove references to the twl4030 regulator"
> > 029dd3ce "regulator: twl: Remove another unused variable warning"
>=20
> Yeah. 32k clock is not provided by twl.
>=20
> As I said I need to take a look at CCF to see if it already there. If it =
is
> clock driver + mapping + patch for wl12xx should fix the issue you are fa=
cing.
>=20
> > Let me know if you need more info.
>=20
> BTW: have you happened to ubdate u-boot recently? There is a nice easter =
egg
> added there:
> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dplls.
>=20
> Which means that _essential_ clocks and pads are no longer configured.

anything essential you can list ?

--=20
balbi

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0bqoAAoJEIaOsuA1yqREku4P/jJSac3oWvaggdToY07gPOOt
zwoubyBDmykZwhptSVNy9DayGyhP7sApMsRdD/3lrIDehI1zlewYrjfLvOjoF8gv
RtpRX4/O/w0PqF17sxQ3g13Zo0BX8AWAklvCySJnqjX1WU5FEcVbvV8cI7ppUcct
a93ft5CiCLYq0RBXgFpc1eUNe5TADKCLn4HsBjQmDe61UhSFVagfep6nR4SEgj1x
it/OehY3z5l3DM8Y7CMEaywe/k0bdZ8NDvzSW34J6b/foOKwAibwL1gsyUC/N35s
EZzTY6tcfh8qSd8vx9hLEtTGIfLNw6l7/u6woJorCWPz30XSsrfY+qy0bI8l/PPn
1Pm6IXPbj/00nJE3gzQpsQnqRcofMuc1uON4OCyMTGb8Avqi2gqALgJIhATtzXiL
v0KgLogCZ2TeOvSAx5PgV3QwmAiKQfnY8NO5lvmd9IJGR1Q4r24XbCITvogHszOz
fY/gRTqvoWYI7feTV01fAnIdGbAtJyXsGsS3jcW9fbrz6KngGWBsN775xDFlhU1A
ElphhW1/TG6rk3cTctIAncqeLY2iH8Pz6PtstC31bbFMjTdEfMW5sIzkOlsyRvfU
dAnKUqzEboktvuaNdIyTkaBBSRonuE7XNcfqY1YI67MWJ1EXZ0kYEqibWbdlYVD6
qxrwfZg8JJbDJlPSYnnV
=GAdi
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
