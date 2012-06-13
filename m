Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2FMRo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:44:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321Ab2FMRo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:44:28 -0400
Date: Wed, 13 Jun 2012 18:44:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH 2/5] regulator: Fix the s5m8767a problem of the division
 by null
Message-ID: <20120613174425.GB7804@opensource.wolfsonmicro.com>
References: <042001cd493e$57920600$06b61200$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <042001cd493e$57920600$06b61200$@com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 05:27:16PM +0900, Sangbeom Kim wrote:
> If ramp_delay is 0, delay value can be divided by zero.
> This patch can fix the problem.

Applied, thanks.

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NFaAAoJEBus8iNuMP3dwT4QAIya/8VTSq+CtvSxQOhhXXW8
hJTBBqa/PJJl2X+MBK5M4NAsREKRu0NNnb/l/y27/OBYR0POFYxEJqAQk1oviYex
xHqpeufknSjZlqohYjI6Q2f8rvSOvTKWKYIIfoTbTeLwiJoJxVHiTpygX+sfpTJq
ZfhJZmqMv4tQFrmOrL75yi8i2ok9xL23W407eh+Y2xUNrZTf/Qq6JpVFZnY8YwW2
UeHhJ73Z4Fz91ixczYyp0gn/eDtasL+nvPOL9oTVc9UQtq1INYMTPB5nI/HEl9Xg
tH+XFsfFzVFoY79xBxRu0nngNf9r39CYa2iLzr09zprwVxHXp6Yyo35NvGQ0Pwjx
Jbrs9vLQDvxscK7tD+zM/EgpKEqwYCxp3ARppoT5jw9h6yBQD6+RsRaSDlfxgilB
7vXKmSYHrFw22f+vEF+/IlWNHEVE+Cn+/2fhm60DEXNufnekDmsT1vipQE+lbfwq
Dp+DTbTcsIfD8tNyZey2Bd2Ed6xseZ4wfzp2n/Iaf7oNIBV9JG6BaqqEDwOUo6av
9Sc10o7yDDVELAUlxWIUg9SgaYd1+FMNGYZSLBhdWo1N87ckZEQ0Kiv53Wbwx24h
cN3k/ukxBqWZiJjGBUSUXdZJFhbMIDU1TdfKCerv6YiZlx5o092pktCgZPs95qB8
tggHQoighT+30HDmqs8M
=voCG
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
