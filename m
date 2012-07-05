Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2GEM3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:29:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43061 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab2GEM3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:29:50 -0400
Date: Thu, 5 Jul 2012 13:29:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705122947.GY4111@opensource.wolfsonmicro.com>
References: <20120703123552.GC25995@sirena.org.uk>
 <4FF2EEA1.6080204@linaro.org>
 <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF2F82D.9080507@linaro.org>
 <20120703142123.GQ29030@opensource.wolfsonmicro.com>
 <4FF54406.3000307@linaro.org>
 <20120705094541.GK4111@opensource.wolfsonmicro.com>
 <4FF57EA9.7060107@linaro.org>
 <20120705120600.GT4111@opensource.wolfsonmicro.com>
 <4FF58571.2090807@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rVbcdceMkFY6fDyG"
Content-Disposition: inline
In-Reply-To: <4FF58571.2090807@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rVbcdceMkFY6fDyG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 01:15:45PM +0100, Lee Jones wrote:
> On 05/07/12 13:06, Mark Brown wrote:

> >You seemed to be suggesting that your fix was in some way related to the
> >DT changes in the MFD core.  I'm unsure as to the relationship here.

> How is it not related? In English the patch would say; "Only
> register the AB8500 via the MFD API when we're booting with Device
> Tree. This allows AB8500 related devices to be registered in the
> normal way, rather than registering them individually using DT and
> prevents duplicate registration when we are not executing a Device
> Tree enabled boot."

This is what you said before and it still doesn't make much sense to me.
I'd expect that if anything your first statement would be the opposite
of what happens - it seems like your non-DT code is doing something
really odd.  If anything I'd expect adding a DT to add duplicate
registrations, I'd not expect it to remove registrations. =20

What I'd expect is that if we can figure out that we need to register
the AB8500 automatically without any information from DT then we should
be able to figure out exactly the same thing in the non-DT case.  I
would therefore expect that the change would instead be something which
removes the other source of registrations.

--rVbcdceMkFY6fDyG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YizAAoJEBus8iNuMP3d8uUP/1LfnYWliblbOgAzieTS/GrN
JZpuQ/ykVc35W8/gkQgvoqL92LIsaKh/jF9PhG0ThHHL0yauihPEZOPEAFINg2Qh
rAWlEVVeEcemufpNEHt5A1Wt5KjBIBtkNZH8uEqB9uDiHz0AmCh+Wcf3na1v6XA+
yIbtljKR0fKr6p6R2la4WOqv+gZfKsc5uCfSfOYnXNVR9nNhBBpq4YVCLZPfiAfu
njs0xLUZYbswbQOukJRPtnhzUPJmnDweyznjzPlOOsxgNOwcajkkk7azqlf2LE9x
RGJGLux9Z6I0LMwjRJ4yw9aaFuf2tco01adAnXsXuEat7VoO6COJ5IoVK7cBO3iA
KgcHhQ3DoQoJmCxwgzxpfxY47K12WMq+feMKXM2NDMC2ep7PYY0951c+69hurhCa
GIc8A8Ym9eZh55rQwJvzpHt4cT7fO0VREXiO9sGvIO+rl/rIj+oKqM+aAA/iNFzO
9UCs7Jx4h2VU/Ir1MMy/1rRJYUtEePKp6whl8Goq3DZdn+yaTf9rk7G5PFyWJMXZ
aMdG3miJN/aJS2UEumD2zFJq71NaGioL41+iI5msyv1wg7Ww0UhdaYcWwaeMHA0D
h1na1tGfrhZ+NFUaA5TPwefQHHmxuHiX1tdou7HGR84OaBJa/JwpUKyHuT5tStv/
h631AuPiW+uP+csXA+6x
=JZt3
-----END PGP SIGNATURE-----

--rVbcdceMkFY6fDyG--
