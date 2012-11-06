Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2KFILu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:11:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab2KFILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:11:48 -0500
Date: Tue, 6 Nov 2012 09:11:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121106081144.GB3283@opensource.wolfsonmicro.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121103201310.GQ16648@intel.com>
 <1535917.BaYBBNgGy0@vostro.rjw.lan>
 <4052192.ry8JrGTr6H@vostro.rjw.lan>
 <20121105105602.GC24532@intel.com>
 <20121105105639.GE1385@opensource.wolfsonmicro.com>
 <20121105120219.GF24532@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20121105120219.GF24532@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 02:02:19PM +0200, Mika Westerberg wrote:
> On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:

> > I've got practical systems where there are multiple buses physically
> > connected, though in practice almost always only one is actually used at
> > runtime when it's I2C and SPI there are some systems (usually with other
> > buses) where you might want to use more than one bus.  Not sure those
> > buses will fit in here though.

> Yeah, I just went through DSDT table of one of our machines and found a
> device that actually has two I2CSerialBus connectors (and those are to the
> same controller). What I'm not sure is that is it used to select between
> two different addresses or doest the device really have two physical I2C
> connections.

That one is likely to be one device that responds on two addresses as
others have mentioned.  You do also get devices which have multiple
physical interfaces for various reasons, such as having a dedicated bus
for some functions that need to respond quickly.

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmMY2AAoJELSic+t+oim9kiQQAIFCLPY55x3yX8MoBgURppyl
Y4+/Nwqxv3ALwVPr00JZ5Zi1UZRoXPXwvuk8GxpESafQ0ub6GIqg7jnqaxBKB2fv
rLgJ1kQMpzRF2v40/CuA7mmbruLAnXhSP8C9fVtXs4GjKHMkGuZCHb88+P7kxXCz
jQEZkM9Yxe2ND5/BQwBqw+xkSHwrswrZBwwRO7to7GO6d2ZveoDqnymi4dMeBzWg
fWCk33qLa4InwJjjUmQeOJdr6T8s8Y8L2dVioXM4Vu0oNiRNBXHy8ES+lVl/ziqn
eQj89BpL84jwPdPkILlnRprOjLzpTAP3dFbttoyol9+tqFPYZMmZFAP6+uJU6TmZ
QZwQdvSp+GWePU8O7Nt9e96NYMPmIiG13VBfbLIJRoAWQQIEbB7TrRlfjV2QicXf
My4QRv2wl15sTePF9NVKjX15VsTGcRCEcUFZSYv4j8XdjKLZnJnQgidVAdojaCH6
6k2LstDx7HmgF4z1SxR/O9heCdONlsTosUerTpqWhQLqIQeb2x670xl1LWjwjkXC
fcNRNzOGwy8NwqeS4PqIosP3hwPNn+pR0VZcfTyycEgLLE8D2ZPcW4BFTANJxp3x
6ek1jCQlsFMSOSVYvRlYdCqOss2Tej7awRlfdVmOJRskX8Av3YqMRZ6za2KovfoT
uCj7ShlU2Z8rxwqgRWZZ
=GQa+
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
