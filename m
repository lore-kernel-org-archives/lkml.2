Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DEJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:45:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2DEJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:45:32 -0400
Date: Thu, 5 Apr 2012 10:45:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, christoph.mair@gmail.com
Subject: Re: [PATCHv4 3/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120405094528.GC3129@opensource.wolfsonmicro.com>
References: <1333610535-15804-1-git-send-email-eric.andersson@unixphere.com>
 <1333610535-15804-4-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1333610535-15804-4-git-send-email-eric.andersson@unixphere.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 05, 2012 at 09:22:15AM +0200, Eric Andersson wrote:
> The bmp18x chip family comes in an I2C respectively SPI variant.
> Hence, the bmp085 driver was split to support both buses.
>=20
> Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
> Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfWmxAAoJEBus8iNuMP3drTQQAIAvoS+tqoWzx36l+UK+icA4
R6a63n1RiDq1aaFx21unG6ydnLJX7AjR+ko8A6x7lqUBoA3YsF0kuBnqWe4TWNbm
O6P0fhBj0jn8KJcs95/l2d7tYD8urLhZXN53vljW6YdM3HxaD9HjOLRj3aKn4WbV
kQ4YSwWWhqN3cktg1hhgTw31M2iTFt2JS4O2cCU7NLEAhsDjam6IP6jude0R6dvy
AzVw65C3yOolHFWkdVIBce6mA883h3CDyYxhI33K7ernsh5BVVpcOqGbJ8ASDFbl
p9sLHU8wOTXXy3nMW+36SK3GoIjrrghnzcJQXM2VihhpzTJ6xYCY0Ww8OXTGMpJn
nc6DkdQC3h+Y5JNIi+ytS1DFkx6r2ZaX4vO635lRj2SM7QumsMBlBdlW/00pPnrn
EH7/pIRBdJ4cY7uP9xf4lK9KYc8qNseSZZm2MnMnz6LNQr7dFymb2blXe1HJkov4
eraasSA/idSJXdOXTYy6z3Ktkgkd9ZPFZjndWOSHvKt2ZRZVIGEDoWdikloPoHsX
dBBLQD6iDW5K+yoPVzYT1bVXDAuXdkNXfl6imQUY5aK4uoSLCxl2KvrcMwG+aLdk
eIuj7nNLd6/PaW/+q0nVM8FuIKXASVuOl2WKmp2yeMPYeKfqi383u3ykvzff7EHs
SSAFzBU2Ye0pcH9xXeU1
=lDvS
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
