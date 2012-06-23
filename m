Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2FWLRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 07:17:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab2FWLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 07:17:06 -0400
Date: Sat, 23 Jun 2012 12:17:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps62360: Remove chip_id and voltage_base
 from struct tps62360_chip
Message-ID: <20120623111703.GV4037@opensource.wolfsonmicro.com>
References: <1339637906.16332.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hIhQBbMWEy++B+zM"
Content-Disposition: inline
In-Reply-To: <1339637906.16332.0.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hIhQBbMWEy++B+zM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 09:38:26AM +0800, Axel Lin wrote:
> The chip_id is not used.
> The voltage_base is not necessary, set base voltage to tps->desc.min_uV instead.

Applied, thanks.

--hIhQBbMWEy++B+zM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5aWlAAoJEBus8iNuMP3dS1sQAJTp7vNwEHSEq/gK3chXEFoK
jp0cxS8gyIIXSSBBhn7v0hcvnI4rYSuPXUEAEqLyZBpT/6ur2myXbksG/anJLiCx
ye2P/ijJ7v0SMYEUMydUHocYtR2MaFtVj9nrtxufiBiM2WoA3FXLDHPstSvfJzpA
gT6rb05nL7E8y3H9KEA5Pn7J7AUkoxm99zJyewoW3cSYkptU52ADRz7PvuQIs/K3
vu9WnKGY1hCymvAA4CRgfYWVU1b063TpzZVz0DUEDCmBlvjS/cH4O3z7oWgYcBo/
mtUnqE9AWv/QK9QKjGX9LqZe6JtuR+R4gYzO6pUScfN7u6MLpQN8sA2UL0Hl7Rz8
Jt5KDog10dLcjAByS+3VuDEd+jI2tirDMjg76+D4Yd8bV21F2OlNqnJp/HlCbNk5
dbnZ14X786XSpcGT7Lf2DT32Np2XAJqLk4LDwhaDbxh19VPzjaNQ6ysF+RXVLDuA
PvaK34fcde5coiexZs6A96b1MripypH34MBhbzs/LIvPnAKMKOGFC/wXviBHRX89
6oFIaIqpxr1FQQC5TcMfmlOiyew2iydnm8osybJvQiFyvrLUbhSMqVEYtX+FaQeN
hxlyaH9lMW/w5hp8nZjopbTx6423k9Pk+rSbsuME37suVSQJJyNZ61kaVyI3SD/U
gkUN/wkykezSiTUrbReC
=Mbig
-----END PGP SIGNATURE-----

--hIhQBbMWEy++B+zM--
