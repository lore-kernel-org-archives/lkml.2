Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746Ab2FEKWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:22:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45399 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761716Ab2FEKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:21:58 -0400
Date: Tue, 5 Jun 2012 11:21:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: Re: [PATCH] regulator: tps6507x: Avoid duplicating the same mapping
 table for LDO2 and VDCDCx
Message-ID: <20120605102156.GN23408@opensource.wolfsonmicro.com>
References: <1338857893.4166.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6yHiY5vv/BiPjcMt"
Content-Disposition: inline
In-Reply-To: <1338857893.4166.3.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6yHiY5vv/BiPjcMt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 08:58:13AM +0800, Axel Lin wrote:
> The voltage mapping table for LDO2 is exactly the same as VDCDCx.
> Thus we can use one mapping table for both LDO2 and VDCDCx instead of
> duplicating the mapping table.

Applied, thanks.

--6yHiY5vv/BiPjcMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzd29AAoJEBus8iNuMP3dpewP/Rv9i3YdXRXPlLRxUmBoDd3Z
3D/QaXk9iq9VP1URlDGyAWOocTxVIOtUvKaB9WM8T+4YDcVl0ZQO/Nvy6fsMyFWC
EGgB9lJmn0xLLbuSX3h6wFzqh+iJw+r0ycYdkBS02VzXf2XwneCp+zc6JFlmJooU
PNxFeLKL83aYr7uyx0YVUFCim4+U3j0bGhwGAC/Sb526uWb1H5n5T7RGAq1O1vKd
YSqYpMWCGad3mggnm8CzxEO/5P4LQ0RNzgttpHiYsvl7dmpNdwOykUVix9t/z17u
9fL66UOMFADJYOPIO5WBh6+9armTz220WlzUAf8RJif5AzC+8B7MFdOhrALmiJWO
tR2qNDkbLX7bUlMUOb1B29K6ByN9KX/iEcUDJoyoGA+E1p299xE3ajV89ca1zXYM
J/QM36QW3RdTSlLV0mPJPhFnIkh1mlhNCFJ7wVLUv/KKgoDkCrcOCiSEm0GPnLvP
RdpGpvkclKvLr9+fqP/ZfD72sEEGlSNCIs3Ur936ltGD4kjnLstrpuXh/GTDVyGc
WZHsdB7wu/r2Xi02mjVG+rHLWn4RkvGduKwXXnIN74ioLcDtq5sKEfNDVvZdUyJC
ywp//F6WYTs3XpvhRbVu4Xxs31X0OmpJ2N5oELHkRgVAF5tF1M6gp4YaL86349Cw
ILumykn8YMxvIr0wvInR
=gAQF
-----END PGP SIGNATURE-----

--6yHiY5vv/BiPjcMt--
