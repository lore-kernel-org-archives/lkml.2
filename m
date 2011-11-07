Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1KGKEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:04:53 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50400 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab1KGKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:04:52 -0500
Date: Mon, 7 Nov 2011 12:04:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <'linux-i2c@vger.kernel.org'>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<'linux-arm-kernel@lists.infradead.org'>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'plagnioj@jcrosoft.com'" <plagnioj@jcrosoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        ben-linux@fluff.org
Subject: Re: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Message-ID: <20111107100446.GG4265@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
 <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2011 at 11:01:27AM +0100, Voss, Nikolaus wrote:
> Hi,
>=20
> > IMHO, you should split this patch into three or more smaller patches.
> > You're doing lots of different things in one commit and it'll be a pain=
 to
> > bisect should this cause any issues to anyone.
>=20
> I didn't split the patch because it is virtually a complete rewrite.
> Due to the severe limitations of the old driver, I think it should
> replace the old driver.

The final decision is up to Ben and/or Jean but I think we should
always have incremental patches, not sure if we should allow big patches
for the reasons above.

--=20
balbi

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOt60+AAoJEIaOsuA1yqRE6F4P/1V3LTFfsTP8F/KVQbsrCgU1
LWwGM5A1xQ+RNJ4t6+gQWTBSZRCjtldZm6MeB68W24vSuT/onqWAfXmnsmUHkg1B
mBJjjYEzdVtjgK48gywc9QgeTvV82TEeqHK3IXYvHzGZNmuhsF93Yi0xTOZzEVlW
Vc2g8cJ9rfsAILqA/FQxNzyEv03xQo3FVT597V/Uuz86LJy6asgDGihBhwNQE2qT
lrAxfWYQ6anBXRpA8RZo1GdxPkRq569cuAee6cFydlau0293d+CXB0c0zTBF0Ej2
8CS3to0R4MFNxd5No5JtyxAAVKbdZRrfYWBPa50IuirMiDSBfGgy88U4g0c91L66
zugpkwTCkg2Z8Zl4tnD0L5tcRhzePnyw0XUEXbr9j/fYX3URm4hYFWzXGjhLI5CN
Gb7ba9xwYmmbALOWHpmccyjNbxDR6hHERsdvqcyiIwX7XzkwM+iaNu+k0z6VB1Tk
Nsarmw6N8dX7aIO8WohY6c1DcN80np+az6reuBQ/MEqDzrumWCDGYs+9VKyAryXh
288fY2Fz9g5BuPL0FTlXo+Dfsox8MtpKLI8yvTqonP4YpBA6uVr/rI60XSr+xoCt
9TQvEsgAPm+O9iv5AYZy50aOUQNVb8/KUk5yPwfi2cEc2WY8MClu1gS9XvZG0SBZ
ofoMmBtqVOWBPluOkg/H
=HjMN
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
