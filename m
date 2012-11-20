Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2KTAoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:44:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44773 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268Ab2KTAoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:44:08 -0500
Date: Tue, 20 Nov 2012 09:43:58 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
Message-ID: <20121120004356.GC4483@opensource.wolfsonmicro.com>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 11:52:42AM +0100, Guennadi Liakhovetski wrote:

> Thanks for submitting this driver! The notion of DVS regulators was new t=
o=20
> me, so, I checked http://www.ti.com/lit/an/sbva020/sbva020.pdf for a shor=
t=20
> description. After that I had a look at a couple of existing DVS regulato=
r=20

Do you just mean regulators that have a quick voltage change ability/

> drivers in the tree. Well, I came to two conclusions so far: (1) The=20
> current regulator API is not very well suitable for such regulators. I=20
> would imagine, one would need two methods: for setting the "normal" and=
=20
> the DVS voltage. Instead of this drivers are trying to be smart at=20
> guessing, which voltage the user is trying to set now... (2) Drivers do=
=20
> this in different ways and at least out of the 2 drivers I looked at both=
=20
> have bugs and different ones at that. I'll send a separate email,=20
> describing what I found suspicious in them.

The thing I'd like to see factored out here is the LRU mechanism,
otherwise I think the situation is pretty good.  Some of the older
devices should use a different scheme to modern ones as the hardware
they have to interoperate is different.

> Of course, all the above was just my DVS-newbie impression, which can ver=
y=20
> well be absolutely wrong.
>=20
> >=20
> > Add regulator driver for this device.

*ALWAYS* delete irrelevant text when replying.

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqtI9AAoJELSic+t+oim9tAUQAIGPwBl4tnRyW1+vzyoYcxHf
MrqNubkP2+HSdXoMGLmFQ0hDju5bcasgX5VqRlH3kuEodoeTzEjyTlcR3vY0Y9M1
QtU732lnkZqtI8zJ46U4O7pZaIk7H1CMmQ2Gu5/ekWq6Ks4+WvCJ+8h9xkSCFAoE
4xjkMhGMd8dZGzwIH6vXPQ1Z5uwpwiAUBR2a9pkR11J4y4ShUx72AmCeIylvePyp
6yT9dBUziXn9wLYBBA86iwHA5H49/qENm0G2+EyxcxzcJNejudfZC6hUNbZJqCZc
3G0b35nSqLB/1i86z8YchEmHjcQfPFftRe9Qc7EaofMXeJbKjzyngL6SLwq1XBVA
t90hTfyJ8Cc23xQa9bVENHOJ3r9+VD7MYVw9W4aBJE1rrcyhVjZr+fRIfyXWPRDb
SycPJ7o5fBeKSQu4rPUc0qJMhMEg8LDpNPiD6lOLEyFsDMqFbYND2csa9Udiaf+S
Kcay/ulTOhwJvNHE8juF+Lfq32WAfAkNjNpH2zlstnxwQshV2fc489a3/wSWp7DI
Z4cyTDanUBHZf2ly5JRcvhVJBDPE5W2fT0QMQlUkgYDalnJrLsc8MP4VvDCMnAhQ
i+4mX+AwGx6+zRMOoEPI7kP2g52jCtsh1IiQ+TfA77BUnIactHA9At8KsNNk4ruk
rUcip1jdyeLcRz3Ah06W
=ZbAY
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
