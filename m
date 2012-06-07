Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2FHAxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:53:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37536 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2FHAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:53:36 -0400
Date: Fri, 8 Jun 2012 07:27:29 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>
Message-ID: <20120607232728.GO14525@opensource.wolfsonmicro.com>
References: <1339036710.7309.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWJEtCrVvH5hpatL"
Content-Disposition: inline
In-Reply-To: <1339036710.7309.8.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC/RFT] regulator: da903x: Don't read/write to
 DA9030_INVAL/DA9034_INVAL address
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWJEtCrVvH5hpatL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 07, 2012 at 10:38:30AM +0800, Axel Lin wrote:
> For fixed voltage, DA9030_LDO13 and DA9034_LDO5, the info->vol_reg is
> DA9030_INVAL/DA9034_INVAL.
> It does not make sense to read/write to DA9030_INVAL/DA9034_INVAL address.

Applied, thanks.

--JWJEtCrVvH5hpatL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0TjaAAoJEBus8iNuMP3dE6gP/AmCwhrM1qRf9Fm8rcF+PrpZ
PGzWNaokRbHsGITSITTkOcAu51J1uwmT3Rjz2o7NPB/qcsAQVMyG2uvsQKnT8ph6
ewQU46b6IwIMfCkHzCl/8rkW7rKByzFUom75B2B80aBJIOkxayBtdybh5p8QEBFE
pZspmtbGlNy+HGAoM2Rwb1FWnVq6wdj66kG/8xbNf1DeW3vGyuZZgdfhazTSIk+7
TVyQ56ltnDDfWPV3q76OP8x2Mb/qkbKuuQmDNdOwBhmXvSOaZ4h/sNUhxi1VnAmG
SkUQzcNIAtKFQwCe5cNmD6ikEc/eB8xW7qp8aOrUbDHdt2OkSnzD80Mm3tyK3oI/
QgTQNmy50P6YWk86IC2p+Tj10f5V16I2iTUo+x87ZXF2RfeMkbcsYpVay7WoOJED
uOqpTEMX4s+I9Akf0pctIrSGNdfNsjJpzODkeuKM73ZQrXouO2id4gsyxUpWons8
F/ORo/0NO+TGxewlcagldjDmPh+qWaFqvbZrVrOeWSeWm0q5KDzKkxxq+0Dqdu6e
ex7wgJNEK8vSI6tW6OnIYPBCTIjmUUfsCUA5ZOTmKUh5FkS4HIerLdqkcwczcBfO
dkBs3LBpTUXzDXEhXO60TmJBSg0v0XsdHQvoSCLof/P8pfnuQdbhT0fPjpYpH75R
u2XO23XFJPaUwpwIb/nq
=HL+V
-----END PGP SIGNATURE-----

--JWJEtCrVvH5hpatL--
