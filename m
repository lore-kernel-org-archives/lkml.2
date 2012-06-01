Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2FAJwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:52:12 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:41263 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758809Ab2FAJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:52:09 -0400
Date: Fri, 1 Jun 2012 12:50:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: gadget: pch_udc: Fix likely misuse of | for &
Message-ID: <20120601095026.GG15957@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338408931.git.joe@perches.com>
 <2530fb0cbede64dad718d41012156043d1ca424e.1338408931.git.joe@perches.com>
 <20120531072541.GC5377@arwen.pp.htv.fi>
 <1338493483.7229.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
Content-Disposition: inline
In-Reply-To: <1338493483.7229.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 12:44:43PM -0700, Joe Perches wrote:
> On Thu, 2012-05-31 at 10:25 +0300, Felipe Balbi wrote:
> > On Wed, May 30, 2012 at 01:25:57PM -0700, Joe Perches wrote:
> > > Using | with a constant is always true.
> > > Likely this should have be &.
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > this looks good to me. Do you want me to carry it on my tree ?
> > If you want to carry it out as a fix:
> > Acked-by: Felipe Balbi <balbi@ti.com>
>=20
> I presume that question is for Greg.

Then I'll take it... driver/usb/gadget/ goes through me.

--=20
balbi

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyJBiAAoJEIaOsuA1yqREM8AP/1Y7EPBUd1ix0k73h2o97EPf
yWFwAh2c1VeZqm1J/Ym+2eNLVU/TqVp+j7cVlLWdIqlRiQBFyD89f6F9XvqjgaEi
715ZpVcVFS6LaRr5NSe48Tm9+o7aUKkQsWbzFg7KphXK4FPg5/ROVepETacMFv1K
xXm/e6l7H33Pe4GGNFBFsce7qnHCmoh3DnXDl0keuGclHu2a0+ExqkDqRsnpPm4Q
y5xN1XGY2he9JYJQX6+SsOXDJC9gDGuxGPD8ijbBRkJARsgsnBoxgy07s4Ss4Y+A
9nwniQiYAtWdAgcztV3oR09cnk2/NbfoV6c/2cKAnKbbXS2mztne7aAk1JVUHk1c
nkLyKUBKKcPeWidT0FaT4ec1zWsVumnKGncp+zTYxo1OIgF0EL4EoJZMIxSjRr2Z
H3czYBUpabZbTX2hP2zBMEeVhyE8JKcc2CDjpRXKLUQIsY0qgplmYLBpGRKd+9j3
p6KGcaCouZbz8aQw2VL5Ecy9nu8bCcFWe+coZQ5kmgUelIQtgdoWWlhGTCBcB+/S
d+5jrbpRC7TB5kJCdkCRSs+60cBFFq8Re0cgmFhVNbygwRN+EMnJy/hEMSijyn+A
f7aD7m+OtENqtAo9qLpbg1II+DtHS9axYw4Yx9QUSIJ46KMeYFZUyBjgD4HXYmOt
rPywMQGQMypdsmKlS5LB
=H+Lg
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
