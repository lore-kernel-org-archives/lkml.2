Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2GRJ7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:59:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58995 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab2GRJ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:59:39 -0400
Date: Wed, 18 Jul 2012 10:59:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Deepak Saxena <dsaxena@linaro.org>, linux-next@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120718095937.GB22739@opensource.wolfsonmicro.com>
References: <5003FB7C.4030509@linaro.org>
 <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
 <20120717133550.GC4477@opensource.wolfsonmicro.com>
 <50057058.2060002@linaro.org>
 <20120717142222.GE4477@opensource.wolfsonmicro.com>
 <50057C1A.80606@linaro.org>
 <20120717152001.GF4477@opensource.wolfsonmicro.com>
 <20120718053341.GA4009@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <20120718053341.GA4009@S2100-06.ap.freescale.net>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 01:33:42PM +0800, Shawn Guo wrote:

> I have an IP block getting different FIFO size on different IMX SoCs.
> We could introduce a new compatible string for driver to figure it out,
> but I think the simpler way is just have the data encoded in device
> tree.  In any case DT is not completely limited in encoding board
> specific data.  Today, we have IO region and interrupt number of
> hardware blocks encoded in DT, and to me, FIFO size could just be
> another aspect of hardware block we could choose to encode in DT.

So, this is part of the problem with encoding the description of the SoC
into the DT - we're not doing a good job of splitting out the silicon
description from the board specific description which is not a triumph
for maintainability since it means that we end up needing to modify the
DT for every board using the silicon if we want to use the new feature
(assuming people maintain binary compatibility with old DTs, which we
don't do a good job at either even for established DT architectures).

It's not the using device tree bit that creates concern for me here,
it's the fact that the board and silicon aren't being separated.

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBoj1AAoJEBus8iNuMP3dKsoP/jz7hlUOFJ+Hq5WtbuQwHWj3
lPVHrs2rkZzb5CEXnnJ2YdfnwouEhYtoH/SxypUSlxOa8nFqjH5ZwF3Sil5IS8RC
cYgOT6Olkt684XwtTx6J2Q40MpY0gVCCOCKfbnc1lp6t3mnySNtSEuwYJGWAaeps
UgC3IqNrC0Vi86+vIETuJ1JU8JVpjwVuko0OD0KRpyckbnPkNpTM90kKi7DlsKI1
gyvxWpDp8no0liclfb67osBPXz75Q1okzU6G5Iz2N3VWz0Tj/aHOS8JMQ7ZXWBQI
FcAqHPMxGeq6Ez22HPUMeJ4hcRwFGWutPFgbsepCfU+qZy6UbiMfWTIOmuHF35tW
QkEqTWgtpJNlzSegueiiGpR4KUKtSOLU2+qBVEAH46RXIbm7iPnepi1v5vka2b0i
Pq1OeYXyFtkVIfg5vg0bnPXsuZ0bJDkcyA/i1Cfc3Iq2lkNv57CUh+dOXjW4y38b
qcXxNwy7hPewbe5dn10hyZkeUj0Gs2sFJn4upMNWdKh/f7XwHAWac+nP4BvTLRCJ
z7L2jeSq+Ldi1OMcGkB0i07dsaI0AGhip1ynSxJY1c+ohhwt5RUbhnXKmIZy+7PX
vANGifd39Jv5vvYdVsjupm5eEdPiNmDqboS7RI0NCQPVNw9WsKv6jFwW/0jGHdvr
00gtjLoGNXqK3QPT3D0d
=HT/j
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
