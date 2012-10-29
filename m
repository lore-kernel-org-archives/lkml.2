Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2J2SPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:15:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2J2SPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:15:37 -0400
Date: Mon, 29 Oct 2012 18:15:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20121029181534.GH4511@opensource.wolfsonmicro.com>
References: <20121029114848.cf0297e997cbfc9c2198fa5d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgApRN/oydYDdnYz"
Content-Disposition: inline
In-Reply-To: <20121029114848.cf0297e997cbfc9c2198fa5d@canb.auug.org.au>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgApRN/oydYDdnYz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 11:48:48AM +1100, Stephen Rothwell wrote:

> Caused by commit 2882fcb3cfe6 ("ASoC: adsp: Add ADSP base support").
> Please build test this stuff - there is a typo in the Makefile.  :-(

Actually already fixed, just forgot to push up. =20

Honestly when I'm travelling with the automated build testing Fenguang
and friends are doing it's actually faster to just push things up rather
than doing testing of branches like this locally, their build farm
usually kicks in very close to the time it takes me to do a single fresh
build.

--OgApRN/oydYDdnYz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjsc6AAoJELSic+t+oim9FjAP/RUaWubN2JelVxdAOdniW00r
v/sRNJgPnUZFe2ZTM1/Ccm35mQIr+RvWeugG7TIeGGvXX7EsIPNdNvxq2za8XqJC
mne3J3kVitOim6DFUG6KpuBI2zxVI4pOrky0O+vZDZNq3qqQPgiB1OqO9vRsvWd0
9gLN4qb85zKo+IlpRb6xiNcPKwDeyg5W6yciqbCrdMkF3syRakaS/f4PzhzNtTHg
i4jPaonIZDsGhKmH1x4my1fke2cFx2K1PXU0fIwG3MM1vrgEOX76Jusu08ep+R29
xW1vSitFEo498IoPhbB4hOiq+R/80Ley95o7wPI8bEbAW9toEPHIxTmzOK9n/uXV
Gd+3cbM/UYUdegnMgT/qzHta4sg/MDFR+xgZfeK28lsDSiOsb7Jnbneywg0SxYem
U+gykq5we4f2PIwl9I1PABSKiJqYQZzjgO2hMZnx1ZCHN09Y5Z9Whq1OeIDzLZuH
RO7E3CnePSfnr3p1x/QwtlgM5u+2yVaVll6Fcp3UFxgjjwn68m5Tww6uBKY7XOPU
cvz1kHV3f0GlKdyVvpIL8caMhTFHlRu0EmQi28APJ51fk27G+vgPzshRnbQQxIRz
KA83XmZce8MZOX5/UDq98zdW/CrHBwHV98DF4egbeTsJWppQHtoLwOP0Yh3c0cyp
EETQRZsW13U9eWTFjgSL
=qlaf
-----END PGP SIGNATURE-----

--OgApRN/oydYDdnYz--
