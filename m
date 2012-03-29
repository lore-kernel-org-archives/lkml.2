Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab2C2LHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:07:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52180 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817Ab2C2LHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:07:18 -0400
Date: Thu, 29 Mar 2012 12:07:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Only update [LDOx|DCx]_HIB_MODE bits in
 wm8350_[ldo|dcdc]_set_suspend_disable
Message-ID: <20120329110715.GE3668@opensource.wolfsonmicro.com>
References: <1332989256.29774.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline
In-Reply-To: <1332989256.29774.2.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 10:47:36AM +0800, Axel Lin wrote:
> What we want is to disable output by setting [LDOx|DCx]_HIB_MODE bits.
> Current code also clears other bits in LDOx/DCDCx Low Power register.

Applied, thanks.

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEJYAAoJEBus8iNuMP3dpQ0P/Rh2Zb7Gpdl2FE0Wgag07ygL
25PEtatJtOIrjE5iaqDg2fLkLVNTzPeSNZFzZ3Vz/mKt/7YSE85ouPrIWHXQ+Ap8
oLAVpHdQbcT/e31MiJW8QhDLFeZKtVjsFsz/1o//zVmh9Whigaf9oWDlVSGGoNC/
SjrnMdRr+l8q5VfEnejvEqpEUn58z+TmgAykdAjpm85/pxCd9QHWubknkWgaHSb/
367VVylc4bQWK1425avwIXbib///o+tpTo4BxKXNK49fr8Mzgl/od2K7eBRdDj1z
ZF6G/erECAG6OLiJs2HXj9xzRuKpJO58tH+qLhkWxlMD/olHs39EvtuqDY52Rq8E
sRo3sNxqjUBJwbkxDyKYkC3F+KQp42U073LW6GiBWHYjWS1s9GG9RKqd09H00S7d
WPwJd3Mrq5RpNvs2iHPpaOyRfJOtDsxm9CCGoioHGwXnt6+e3yCzgMLeu7vXG4TK
RIgEwfhLadpak7ygN0bHQCGlBBgPe/QqHTGCsqH0IaQbiM16+kQHTc1LW8/rrhQj
39tl+3aqX3J9geSYhZ5vGO9/R2a3ohlQhCofSF/XLWYeLZI+/UHLUwYHSBfZ8ApR
1lxCwOz3cx1t88FEBGJqx+wbRhHzXijUwENvMSWaz2hNBUBcOXcXbx4z8wptqG/7
/Rj20OT1XXwfQ/06kQdf
=dVf0
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
