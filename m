Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2CZK4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:56:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261Ab2CZK4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:56:53 -0400
Date: Mon, 26 Mar 2012 11:56:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Danny Huang <dahuang@nvidia.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/4] regulator: tps6586x: Fix list minimal voltage
 setting for LDO0
Message-ID: <20120326105651.GI3098@opensource.wolfsonmicro.com>
References: <1332553050.14114.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pe+tqlI1iYzVj1X/"
Content-Disposition: inline
In-Reply-To: <1332553050.14114.1.camel@phoenix>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pe+tqlI1iYzVj1X/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 24, 2012 at 09:37:30AM +0800, Axel Lin wrote:
> According to the datasheet, LDO0 has minimal voltage 1.2V rather than 1.25V.

Applied, thanks.

--pe+tqlI1iYzVj1X/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcEtJAAoJEBus8iNuMP3dADIP/i1p1VavOM2SSTKcM5cnzDIV
2ncNsGHqh/1GYw0CRNspmCzRegrZVfDOtYtw9UFPAZtJ+y7ipNsHkLoveqLFIbdz
qpFvwV0hXgiW2S5mjJsSHNvWCLeAbM67TW8Km+w9ajbzh0f4gHkJciPhx7W+21Ul
glIqpVix4eWxjHCSDuO8golqM4llAuCidSLmlB3vV1BAEJpV/LqVY7adCr3MB3eq
WTxFYqL8ZTKfl9kb9N9cK7TVHki2e7VbWnxvlK0t4C3qlY0mNIyz+Y6UCYRAoE4Y
+wwWbKARv/oyz+avI61CLHAMwriqfhGrn5vc+MTC5x+sK9BS/BRmHmdVPrDW3Akx
IXCV4UfLegx3pxXo2iaIf10tRmqDOxdEUPA9F+c6fQPhEbJ279P41uZVeXM4yrnq
KmQOPgZNI7e53mv3Gc7ZtJXdIOCvR2xSyUPe2/iqMPzSE0ujW+KEvO54JCvu9ssF
MlZGWk/ND98o+oewlz02ZzOo1H62RwGH95FQQ8OI+umr5wGvMUeIbEJUpTO0XAD4
B/3d3Ch/dzEjYpOUhP+WX1bvX2HARH23BiY65LscUJU8QNzYrkaIlpGBDN7QWUpq
lBKVB544snh5hjAHBM4En9KfpK6yIh2RHtdDyTOacqqxs0WMDmTYFe5aZQBtPVrq
xkqVcM7dDP1/ekL0IjNE
=ZEbq
-----END PGP SIGNATURE-----

--pe+tqlI1iYzVj1X/--
