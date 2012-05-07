Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2EGJta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:49:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49895 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668Ab2EGJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:49:29 -0400
Date: Mon, 7 May 2012 10:49:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120507094925.GE4415@opensource.wolfsonmicro.com>
References: <20120503152643.GM3955@opensource.wolfsonmicro.com>
 <4FA3958A.4080206@ti.com>
 <20120504090856.GA14230@opensource.wolfsonmicro.com>
 <4FA3B182.5060001@ti.com>
 <20120504112204.GE14230@opensource.wolfsonmicro.com>
 <4FA3C3B9.3030009@ti.com>
 <20120504121730.GG14230@opensource.wolfsonmicro.com>
 <4FA3CCAF.3020902@ti.com>
 <20120504124750.GL14230@opensource.wolfsonmicro.com>
 <4FA77093.9060306@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline
In-Reply-To: <4FA77093.9060306@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 09:49:55AM +0300, Peter Ujfalusi wrote:
> On 05/04/2012 03:47 PM, Mark Brown wrote:

> >> If there is "irq expander" type of chip I assume it would have similar
> >> way to get the IRQ number based on either GPIO number or some other
> >> enumeration value.

> > No, there's no generic interface for this.

> This dynamic range allocation for IRQ, GPIO will work nicely with DT at
> the end. In legacy way we will need to have workarounds. Or just forget
> about booting without DT.

Device tree is only available for a small minority of architectures.
Just as you shouldn't assume that people only ever use the reference
boards you work on so you should also not assume that people are using
ARM (and ARM systems that support DT at at that).

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp5qZAAoJEBus8iNuMP3dZ90P/2FIQriBYoVERd80IGc+ukbt
SLPRTIDHiVPG+i5dwyMBVxAjs7qEr58x3Mb/RKCzEvllM8Tym8m19+VjfeHWOcxO
z0VdiVcUn3tfI34U2hgj20Za3wQyOsoPF6fkhb3ffI37fCLOzR6SMF3G4mZXiArS
GY4mwNupY1ftm4o0sdCx5sk+G89qtMr7E5A+WBc1EwPkSCU+bG3ag1NEhBNBAdUi
7E3nP/l6Bg/oZYnzbppIxCsFwF/xS4s8QIYl/BcVkOL3W7gi1A2mZJy8G+6Op5ls
726hYTNb00awifsR6wsRAfCjoGkxv31QMbyRxnrb9yRHIASz+TBiwQcEl0tzEtUa
haqoDpzZX3065lz2SjBrzo4vQwMMqOdFzWvMoSW99MNGGhivMXk86EN4YA2dB3za
dEFUuV6Gpte9g/xjW5zVBxbqIoSLglsL+xFboEq7Y2rUefOo0mj6lj4Y+bB3wCVi
wDYOtYy/05blK18IDfRBBF9uQTMAjFZtun5wLaP6jG4Zp1GGJjCeXeFBInMtPcKk
zH4cxKZUzEMxMdWXO1sHJeaEc5dEVxtavrEfuxY6Fq8MHkZDW0xarJ897yHkBDJI
bsEGAxR/uDw63kCdNni1wmqWyf1J4BMWLpiByfj4KZj8oNk8B1yXXubzVHwbNHnp
VPx5AjMhXx4vxDZYRZmy
=9T+a
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
