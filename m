Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414Ab2KAWL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:11:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42328 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761979Ab2KAWLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:11:25 -0400
Date: Fri, 2 Nov 2012 00:05:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, <balbi@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101220518.GE14982@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi>
 <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi>
 <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi>
 <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk>
 <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Thu, Nov 01, 2012 at 03:59:50PM +0200, Pantelis Antoniou wrote:
> Hi Alan,
>=20
> On Nov 1, 2012, at 3:51 PM, Alan Cox wrote:
>=20
> >> What they want, and what every user wants, is I plug this board in, and
> >> the driver make sure everything is loaded and ready. No, the end users
> >> don't want to see any of the implementation details of how the bitfile
> >> is transported; the driver can handle it.
> >=20
> > That doesn't necessarily make it a bus merely some kind of hotplug
> > enumeration of devices. That should all work properly both for devices
> > and busses with spi and i=B2c as the final bits needed for it got fixed
> > some time ago.
> >=20
> > In an ideal world you don't want to be writing custom drivers for stuff.
> > If your cape routes an i=B2c serial device to the existing system i=B2c
> > busses then you want to just create an instance of any existing driver =
on
> > the existing i=B2c bus not create a whole new layer of goop.
> >=20
> > It does need to do the plumbing and resource management for the plumbing
> > but thats not the same as being a bus.
> >=20
> > Alan
>=20
>=20
> Fair enough. But there's no such thing a 'hotplug enumeration
> construct' in Linux yet, and a bus is the closest thing to it. It does
> take advantage of the nice way device code matches drivers and devices
> though.
>=20
> I'm afraid that having the I2C/SPI drivers doing the detection won't
> work.  The capes can have arbitrary I2C/SPI devices (and even more
> weird components).  There is no way to assure for example that the I2C
> device responding to address 'foo' in cape A is the same I2C device
> responding to the same address in cape B.

your ->detect() method should take care of that.

--=20
balbi

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkvIdAAoJEIaOsuA1yqREv2sP+wSsVcN17PpVBmV6Q5ybcvpP
qZ8oHUmVjI6HjCoavqmHh6VPzPJ1OCh7S/RlWdVlLvqh0YQ8jnODU3jYlpwqEbfq
KPe/occbJmAQLc6xAugIfTjA+2Vtl8RYx3vdxYC0q4eqrXHDys5JZ/HHgf8qU8Nb
u0ePE2KsO4Th9I/Ahnlw4I/szgqwrQrV0+gOt5eVK5JhEywbOUslEGyoiXsPXSm/
RlDVKRda9P/HLDWmV/3UPfTUFLkFGO9JcY7pYJIzV4OiwEQ4Yfr3ToaBQ3vK6Q0+
Tpr6daM/8cR8MIfW530fVIoHEbR0J9QJGbBRhU7WhyJ3k/kf/ZWMvxy4r9/0kd15
HWE/4lFSd1vIyAk1DQEqvpFUAjbmfpxQlGp1RnvfWEFCGp4H0g46YpBpv+6wLqn0
AyNCxIUcjrIuQ4aSq3za76VS3vCgNSELs4C8wEv6qktSRWUs/3i3DH6VcrJT9HfT
9AxYKf3p8eB99ZWSL4FiFg8FoywSYh3JFhyzN6w3XD88nULu2quq2/EIm7BYKr5y
T/lIDReu2D2PunzPwL8RBBJuR+ZC7XxanC/Zz9I01Ry6ZyK+R4NPpdYcA7Yf9T9+
jPxJdUXSJFMW6/E4VQ6703MossZy3HlLpC023wnkkdv07ZpmmSQOiOk8ufcoDR1G
0FjCvvcrQwUa5elKGjFh
=JdqB
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
