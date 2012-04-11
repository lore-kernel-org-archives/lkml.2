Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2DKIYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:24:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59318 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2DKIYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:24:48 -0400
Date: Wed, 11 Apr 2012 09:24:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: fix compile errors in regmap-irq.c due to stride
 changes
Message-ID: <20120411082444.GC3163@opensource.wolfsonmicro.com>
References: <1334122642-14864-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <1334122642-14864-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 10, 2012 at 11:37:22PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit f01ee60fffa4 ("regmap: implement register striding") caused the
> compile errors below. Fix them.

Applied, thanks.

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhT55AAoJEBus8iNuMP3dL1kQAIVgb0kglQAsvzpe70bNQ2xh
C7Q4RDgpJdirEIbqi403ph0tFAZtE6cBFkjOJsZaDwBrk0JvPnsWQ+aCpE/rtREj
thNF+SoGlku4m/oUbLpHidyVpqoutgg7LMwvGqFPHI+legSkrbwk7WXoyTRWjGkv
mJBvHi7e12iZFYkhSwg6abZyJAR3fbkFsa3lVQCHwLVhH6myFrrcFYM2/wozVagb
ZPYU1v6/62JVJ0cTdvcnSKhotSSrtdrRj6ej9j2xLRIn3pluxrPdWk5czmBHIaWj
VpQI4V3GKGtOjJpQXoLkepkqoru7a0EBKPvjiZ5jm7LRnbikyp2sE74+CgrpHcKa
dYk0A0PBRld9Rh6z6YPoOi6Mhqit/M5VUjepY4R/z5v/kGAdZT2suF+kPCjh3Tct
N/TsyfmEm9q3lEe0evFiAP959ZoXqJeaqYf+I/vHjOhNowfiKI+GPpIfbAgnrUO1
DQW5cHrfsDKZU0k1MSvorD/htMIAGNZvznNBA167ZaGwDvFK45ZiTv9Nyy5YYcBv
AyPOYBXFtlBsF1g0Z1Q+AuJrEutXGivThmM/Iq5A3Nqf0bc69AzoTvgZkhUgdwm6
SzEJsIXEHuX+GxPOtIEFMqqoQrsqiwvjUNXH8h1zLG22u5CDoemVX5m5fKvOGaFc
9HHRmVhbb367qvG/xHkv
=NZ23
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
