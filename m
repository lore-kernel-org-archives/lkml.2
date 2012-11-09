Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2KIQnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:43:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab2KIQnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:43:22 -0500
Date: Fri, 9 Nov 2012 16:43:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
Message-ID: <20121109164320.GS23807@opensource.wolfsonmicro.com>
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jo46wx5DSA4a/gWG"
Content-Disposition: inline
In-Reply-To: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jo46wx5DSA4a/gWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 02:37:32PM +0530, Laxman Dewangan wrote:
> Sequence compatible list for tegra20-slink driver to first
> look for Tegra30 and then Tegra20. Tegra30 have additional
> feature in HW which need to be utilize if it is provided from DT.

Applied, thanks.

--jo46wx5DSA4a/gWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTKgAAoJELSic+t+oim9t4wP+gMBIewHNrOvAVrYGq9Ozzvj
G5GYSPOfAsMQW5IaOpJ1w9oih7cUSsCsxZjn7lS9lDnTaNSZ9RKWT1VD7Bopzwtp
KU1PRUFLM0VE6ujF/p3bkZrJl6I3iXz38kWE490MXtWC1NuUgxdtt7miLHFL0wBr
cRG6EcJzvfinbLcac8uZm/e3EzqW3jatAOtqJXNxykiV5VBOZcjzv6rkg0a3yPZX
mV3eIPYQMNkLYfxDBuCuUbWKb1tgi/d75qE/vp0w2iUN6T26Hs1japqFNErN6id+
56B/1HzFZ2cBjAPL6xXFH70Y/DLYb9CZnMN3rBw5jYDxbW85ocZic1FgdRh8vc9/
MH5inlcmIE23JTfzX6JFK3lR4JtGHqO6fC1fh2AMtRM6G0O+LuG3SbTkWezrODTk
E2u+CmziX4Ti5BJmtkt+QoE+kW/LIqCeSyk/020cXg+BlCg2pd0cqfUe2TjSooq7
EZRjBdJJeBkmlDjEs2wHwH2IjYZG85+asce+UciB/PsVIgSY6iLdi9g0xMyGvnCw
YU69bFKxLX0XSHKH8ZSlOmB+6aa3+xB7ov2noIxID4SbZ79x/AsOP8x66YcwX2ne
zKS4OuRJBFvI0qc/8MZlHJE7GyzFxeaWrIPPaC22BNJRP7J50KiN0OSmDGECVxoX
nVTzK+H5SQCco3rkidXB
=oZMd
-----END PGP SIGNATURE-----

--jo46wx5DSA4a/gWG--
