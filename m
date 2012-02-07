Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2BGLeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:34:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49055 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab2BGLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:34:14 -0500
Date: Tue, 7 Feb 2012 11:34:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps62360: Remove pointless test for unsigned
 less than zero
Message-ID: <20120207113412.GG3332@opensource.wolfsonmicro.com>
References: <1328583980.5528.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <1328583980.5528.1.camel@phoenix>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 11:06:20AM +0800, Axel Lin wrote:
> The variable 'selector' is a 'unsigned int', so it can never be less than zero.

Applied, thanks.

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMQwuAAoJEBus8iNuMP3dGP0P/AwvGoIwO6kNWZ4aoyy7x02a
ESqh7SNpNjD2Kypj7lwGEYGy+VWIZZ9wtvnB0/PLnbJZNDWVHsRooRyFEJpv8kc+
hmpDLSm2moLzcAGBlbcJJX54XxR1U8H2POuAlkBZuORKvZLnBfrzWHURECESc3DT
ycqSpmPnya9uWn+8pCnUIqG0UPPvp7qrD0bQZv7D2Q23mDjiF1vTNaBwaVh/8ViZ
Jwpk0C0A6H/BmOsZwWpMRxlv2zQ3Od4Erl6rIIjf35IR6PqdKfj90YiJLbr/NQco
sH4mCWV4xMEtuxAGMOlkfM0SFBv77BxI3U32hvukG9CEoPyYSHoLkZhZuCsM/Pg9
1c42T7+DOVwPP6tCt434Rx2blzM29nhksUmYS0ZV5XQ1oIDTSXppPKtvdfuXKvi1
hu5wgRSEJIVtDqEQ3Xg6t5qiXmrH6Gg5H+HdHXaF3Mm6hlyLEDTWOGBqRMabBeXy
36cB0kMHetGoQgXDatJ2DLv+ufqRJKOvHgfOqKD85+xEjn/WgvyGjs/Mbvsw6oly
h8BgnCRQP90vxiL+4N0u1SYExIbPSjsbdTmbA1lPrM0SO7TZeu8KQ0Qil32ebECt
Q6JPotMfurumQy+1k0OxSUzwauVesC+Q+f/6CkXLGNWZYpHcqaR6uHED76Nj53ek
ze/aUwBmE9nUhV/4gRKK
=9KMU
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
