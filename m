Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2BMS6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:58:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35772 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755799Ab2BMS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:58:30 -0500
Date: Mon, 13 Feb 2012 10:58:24 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Porter <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120213185823.GF3494@opensource.wolfsonmicro.com>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
 <20120213165209.GA31482@n2100.arm.linux.org.uk>
 <20120213165617.GE3494@opensource.wolfsonmicro.com>
 <20120213175233.GC1426@atomide.com>
 <20120213180236.GB31482@n2100.arm.linux.org.uk>
 <20120213181410.GE1426@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Content-Disposition: inline
In-Reply-To: <20120213181410.GE1426@atomide.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 10:14:10AM -0800, Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [120213 09:31]:
> > On Mon, Feb 13, 2012 at 09:52:34AM -0800, Tony Lindgren wrote:

> > > Can't we just leave out the .id and have it automatically assigned?

It'd be nice but...

> > Unfortunately, there's no such infrastructure in the driver model.

> Hmm OK, -1 seems to be just used for name in platform_device_add().

-1 is a valid ID also, it means "there's only one of these things so
don't display a number".  Which is sad but there we are.  I'm at ELC/ABS
so I might try and find Greg in person here to see if we can come up
with something better, it seems like this is something the core ought to
be able to help with in much the same way that the USB stuff can.

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOV1BAAoJEBus8iNuMP3dqvsQAJfwoP97Gfeo5KJ+3tEAZ8VQ
dDBE1oQq7A6MIHcq7RPrPGDlNZ1gHwij5YXBESfbn66GrfbXe0oaR5CeumW3Ylce
oA3CaPZGzl3PzyK0WTqsRm5f8/J0zsJNPZS6WoNWFgoX/xQxB4UFO8Meg2aOJiPK
dDEpk56A6NYpZlMfJCjOTQrpPNHmd4CrWEvYafHOioNBcUykyeKfr8rE52MPyqjp
SvWIC2ve7kHi7xPkEF75jqovc7wvKWTpBomDTVuGRpHm2rtHYOLsWcQjqgVcnojN
6PNKFHZjxbB3OrEXmLGkR7iIypbmVEr1NvSffbtkTK4i/e0yy0vSKODjyGJdVUtD
R6o8I+RJCLQQYfPNfbXZZUu03n8OkskmREbpNV/FSi9Uz0uaKRBOiGq/Yk6xWZ2j
m7jbjSqcJkZXTvQenZm5wMcthCbiFFGsRSE9SydASym2XpqOfQD4WdUGtI8jqLJd
L1aYWYJeeioXszQ3lOe+ccRmi6rluF/y9bQAZLO0e58Qr2LnSJjam/ux1KeWwqGI
7BkMaTzSZ0zSi89wH7ga6deAOF44DQAsKGeEdmo0lN992vWoWZFPmr5gvER0iS4G
pVOFjTnRwJ03meTdmBLI2oZkfoJgDldCc+QkQJHeJoYKP2/tMDX4/fwV0KhZOADW
w0Al+u7y/2pJNj50JvZi
=N6CA
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
