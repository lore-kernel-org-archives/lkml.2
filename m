Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2FMJra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:47:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53547 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab2FMJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:47:29 -0400
Date: Wed, 13 Jun 2012 10:47:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: wm8400: Use wm8400_ldo_list_voltage
 instead of open code to verify selected voltage
Message-ID: <20120613094727.GH4545@opensource.wolfsonmicro.com>
References: <1339490095.6743.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Content-Disposition: inline
In-Reply-To: <1339490095.6743.1.camel@phoenix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 04:34:55PM +0800, Axel Lin wrote:
> Call wm8400_ldo_list_voltage() instead of open code to verify selected voltage
> falls within specified range.
> Use wm8400_ldo_list_voltage() here is less error prone.

Applied, thanks.

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2GGiAAoJEBus8iNuMP3dZX0P/RoSizePioIJLTBRhUrihFH0
qStCDbPH/ZfUwI6yjHhxM5iWFLWpJJg5LE9McxjbZHW13NkCdOt/4jpNlAdYCFS/
2YLLHWCoHYT4KXMj+eCXURZ1Oy7x/wkJJrsSA/nGOCjBo7AKdxi4GRskRcezgSzn
Zh8s+SgvnARivzmzbuIE34Ad9l4cVNhmVs2Is7mTAhHNP82KllNs89+MhxMduoX5
otWVEmIzydXGdiBWOow+LCTSpiexla6ZctuBsOCVFHJ2ZPX2mbpCO7yqRlOdHfpy
v3TyacBTvgC/dAh08hbt1CIIbOI1Xpcw8h+TIPxlb3bmDWxpkRk2jsgOdczhfDr/
UD+SXuIXBaPJ66490g7apKRmOH8zkz13wUVFWQDjIYbr5zC1OFU+KC42zC4vOj5T
CelVnVPiEOXvh/pVjREcxhMd7YqjsKYWEmuz1o/g3fOhg1f6J1Q3M+OSAquswBqh
T2XKCYHuVEH8tEqBG2T6wZFmgk3T4Z2gA03nlHYVqJBj4EdoYyg2YkekOpwReLEM
lCf2RCuBwZ2KQ0VfmHesyUdTVUHLG9SYzC+9JG1OVGKJT9fGqnSPKp7jUABLUAf1
5oIZFy++kHoocbL/gL52LOyJuGLfZGxTVOeyzgYxCgOOtNZ03aHxsers7tokX5ag
2gjeQpr0SvHp6FRCnDSK
=6JhR
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
