Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2LXQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:27:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41283 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:27:29 -0500
Date: Mon, 24 Dec 2012 16:27:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: lp3971: Convert to get_voltage_sel
Message-ID: <20121224162726.GU30837@opensource.wolfsonmicro.com>
References: <1355140012.6601.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EyuBRJR0MsVMWKTf"
Content-Disposition: inline
In-Reply-To: <1355140012.6601.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EyuBRJR0MsVMWKTf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 10, 2012 at 07:46:52PM +0800, Axel Lin wrote:
> regulator_list_voltage_table() returns -EINVAL if selector >= n_voltages.
> Thus we don't need to check if reg is greater than BUCK_TARGET_VOL_MAX_IDX in
> lp3971_dcdc_get_voltage_sel.

Applied, thanks.

--EyuBRJR0MsVMWKTf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IJoAAoJELSic+t+oim9orsP/jBzfZocTkf0h6yY9tv6a2NW
qe8oXn6aGWr3V5BkoTGGZ1Qqf1cvrpemmHQMWBFxX0Swb5+jPCF1bbX8F0hAB6ay
AbW2OE/YuqHNWoSGLrycdgde4unzvy1NVvBcPQPKQX5tYJ0/uzYWVsMFxZUNx6M8
YLafqoaeSbL2EH9M8TTi98288lF3c0SeXdomOIzTzyanZBv+QxyqgRYprdw29sQ+
cCewyyzIFHlTHuTsfJgj3DrDord5KGsIChRmKyawn2lU6qQZMa8NeIkRPEyby9ph
F26nCP3jLYK9vsw933fd32UcG/U8qv48RUzo8BOFpXX9rG0XculLMAcL8xyze50U
A3bxBi6PbOhBblwxxe69PUS48xOouO8jcNSiqzHri5DgXFtXew1gg30JJ3swVWT5
BjyQk8i93p2G/8MN5MPIB1I7XjJI9LABIuhQ9NQsKGjEQobbkEuxZBZh/Bc95Rz3
LN1fb6OpNEibZlXIA1UrWino3jYj68s3B57LGgbKtVag8vRftefH7KKJW8sauv7o
rj2EhcCMkQi9lFlUc6I8802+HjpGwZUw6uUlFI2xLq84KcVSvc7JghMS7XdjRKD7
XHPG1J8qaP67SZJbQZ+C3RaJQV9FWb4wgOfl0nDjqnbbZX8fu3PRorxt79iIrmrl
TQqjIS48iNwW4MQ4zcQj
=GRre
-----END PGP SIGNATURE-----

--EyuBRJR0MsVMWKTf--
