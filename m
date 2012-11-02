Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965853Ab2KBLGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:06:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42260 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761147Ab2KBLGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:06:45 -0400
Date: Fri, 2 Nov 2012 13:00:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russ Dill <Russ.Dill@ti.com>
CC: <balbi@ti.com>, Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121102110038.GA19493@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121101124025.GA12489@arwen.pp.htv.fi>
 <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi>
 <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk>
 <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
 <20121101220518.GE14982@arwen.pp.htv.fi>
 <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
 <20121102085718.GF17063@arwen.pp.htv.fi>
 <CA+Bv8Xb4eAQ2po-nwCT6ZXNdaU7cwshVaGC795e3GYZ+B7L-jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <CA+Bv8Xb4eAQ2po-nwCT6ZXNdaU7cwshVaGC795e3GYZ+B7L-jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 02, 2012 at 02:42:51AM -0700, Russ Dill wrote:
> >> browse through various detect functions, yes, some of them key off an
> >> ID, but a lot of them just check various registers to see if certain
> >> bits are zero, or certain bits are one. A lot of I=B2C devices I've
> >> dealt with have no good way of probing them, especially GPIO chips
> >> (you'll notice none of the I=B2C GPIO expanders have detect functions)
> >
> > it doesn't mean it can't be done.
>=20
> Really? Please, do tell how you would write a detect function for a
> PCA9534. It has 4 registers, an input port registers, an output port
> register, a polarity inversion register, and a configuration register.

read them and match to their reset values, perhaps ?

> And don't forget, since we are probing, every detect routine for every
> I=B2C driver will have to run with every I=B2C address on every bus,
> possibly with both address formats.

not *every* I2C address. What you say is wrong, a ->detect() method will
only run for those addresses which the device can actually assume.

> >> On top of all this the detect routine does not tell you if the alert
> >> pin is connected to some IRQ, or in the case of a GPIO expander, what
> >> those GPIOs are connected to, etc, etc.
> >
> > so what ? All you want to do with detect is figure out if the far end is
> > who you think it is, not what it's doing.
>=20
> If we already knew who was there, we wouldn't need a detect routine.

of course not :-) But the whole discussion has been about not knowing
which capes (and thus which devices) are attached to the bone.

--=20
balbi

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQk6fWAAoJEIaOsuA1yqREZVQP/RT6YMon6vwvktoSY2yAZ4CB
JaPsB5ZTkwEds97b/pXZ2HDfcvRjt2N2eoXYv+4oLON46i6ilKnHC6/IwqUeAdur
nObgG0Mu6BZAEzxaVTZ78Gda86R2ROHjUrO3BXoHx4nh5Y30BxdFEk1j4ilSUDrl
5hXYw51TMkKTZ7LOqq5A1Oaw6L0G59MIf/K8L3YmB8XUKseuVyelgrCeTt0cWfaF
mp3uW1KAbU5GnZ3f+B5EbdqZLav8JDp6gw5pFUe1tnzAriSBvIJwGV1AIefpPQHT
p7LGLcW8o77+P65vJJaTlAU1jjFhUHDJu/QFHmTcVyMQIU2FodXFkVVFIomtERBh
xYcFZbkVpP3jQ678cGxQwb8sAk2ic9mgqXf7w+lGvrRmH2xSuHKw3FTC9a/7NYuW
kkpCwX7Cg8DmWM8b/WbWGB97qP9Ump4SMT5U49rVrVCgF4VLR4pj2YrSUTM9dZpc
M1Tqa4oGCUaa/3CCpeKOJeDmDzmuxr/JPf3mGlLOCk5yiWkfspE9boVFu3wMJyi+
4yTdVC5jLKhhVFkH1waFAlBgBIeqdl3EeClsHlfggGrGc+fNPElom4uIWjkt8kWf
Y4C2T1o/0EKXgnQSJruFwSW7a/DAN5G+oILsSiqVil5hPEvZeVrDmHbZYkN0aioc
M3PONFgDLSVgiUSUcx3s
=uaTk
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
