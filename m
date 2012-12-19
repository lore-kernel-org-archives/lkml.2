Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2LSJE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:04:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57883 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab2LSJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:04:18 -0500
Date: Wed, 19 Dec 2012 09:04:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Bi Chao <chao.bi@intel.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
Message-ID: <20121219090416.GK4985@opensource.wolfsonmicro.com>
References: <1355848174.1435.25.camel@chenjun-workstation>
 <20121218152623.GA26077@sirena.org.uk>
 <1355910243.1435.39.camel@chenjun-workstation>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apbmkPN6Hu/1dI3g"
Content-Disposition: inline
In-Reply-To: <1355910243.1435.39.camel@chenjun-workstation>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--apbmkPN6Hu/1dI3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 04:44:03AM -0500, Jun Chen wrote:

> This spi_alloc_device function will be called in the spi_new_device
> function to alloc new device as the master. But other way, it is called
> by the of_register_spi_devices function to register new device as the
> children of the master. I will update changlog to add it.=20

But why is this a bad thing?  You've said what's happening but not why
it's a problem.

--apbmkPN6Hu/1dI3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0YMIAAoJELSic+t+oim9Ht8P/37jJepygeTI8PpDeDauIf23
dqnVNhqstdFjS6ANsI1aV2/LjpR8E9qYK4nzMajrd1ImpBflWYj3/rx3sWrEfUWe
dDoniTdBFFFH1dfsmlA8e2pvfjJO4VERL0DzWYrPG/Y5ik4aeqwALcIDKJQX0fr8
po3gQGYoGb/UVX6WDhc65k1EeG1wxlX9qfWauzyLMQrsv5l58RU0NkJYBKGRaDqD
p/b36dJgjRqCE0JK9hibvib45s1tIBNVkU8rCBH7ss56wP9das7QvjftSdPMtTc/
ONBLjKQ9QzTlwXWYzY/ltC4qLrxCkg3PF5mpma2VfLR9bv9QcYA3LjoT4ZifUG8n
e3qcJ2EjC6EWl7qWOFkEh6PoWfqhwBFkMNpXGYMUY2bzmAO/9Ydgs+ta4d+3CwzC
SdxjNBTh7NEL+OYNjIzkhMm02KZfRrzflHo+PZV/5EEmUE0GS0Vxre5r4Q6ymLQp
9bLT77a+tYFAXuTwsVlsxdMuQW7ry1BMz+XZDAK78lDJ9BsUP4MnpCs3uLAVqfKW
AEc97YHU/fwULF+7zT+rrBkpQFTsMoJVryR4iBn2y+nrraGhj+n6m93QZpeRFunC
50/lPbnXkarKaEfMRDXFFwlTGtaFE1niYzw5OTl2ZZkFKfBYh7iuKOtNL7M8aTDP
ok6JqVqh/+t2yhch5LbJ
=d/KR
-----END PGP SIGNATURE-----

--apbmkPN6Hu/1dI3g--
