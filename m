Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2ETJsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 05:48:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58601 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab2ETJr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 05:47:56 -0400
Date: Sun, 20 May 2012 10:47:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v2 1/2] mfd: Add support for MAX77686.
Message-ID: <20120520094750.GB20652@opensource.wolfsonmicro.com>
References: <1337261967-26004-1-git-send-email-yadi.brar@samsung.com>
 <1337261967-26004-2-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <1337261967-26004-2-git-send-email-yadi.brar@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 07:09:26PM +0530, Yadwinder Singh Brar wrote:
> MAX77686 is a mulitifunction device with PMIC, RTC and Charger on chip. This
> driver provides common support for accessing the device. This is initial
> version of this driver that supports to enable the chip with its primary I2C
> bus.It also includes IRQ and device tree support for MAX77686 chip.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuL2gAAoJEBus8iNuMP3dvFYQAJFpSA+6LbmF0M6l4KRAjxN5
Kjg3J165Ut+RAXehO78I7SJLeJMhLzUTgHzWoSTO60CcNMwGQYnE1XWpviynmkEi
lKuyx85BgwK35rWg80K7LujXMdkLnTzP6SuvrvxtRYXZdYKiYyBK/17ESZHmMAaM
EntYRz8GAYZt6x9MkwL0UUrjHChUET5Niu8y+b/i2nuBNOm7QBfC1QF5KiGOZlvd
u8SIPfDNnnswmydFF2MwlAMVjU0Vn1x92IVZHVx9wLOOm6Q3VGcBmKPULQwpnvdR
H6GfWqImHvLHdyKeiYY3XGQtA3EFjA8gx1jVhfmUt4G7vluxHcRNNwNim8Zt2POr
dZzqUYJSBJJT8c3uAn6qhzAhxvNIs6ry4M8wcm6Z+VWWJVC9P+sALu7vXar7yneV
vn7JdrgoeEhPaoxNwktsyikMMuVebUjyDvoELgQib2q6ZkZJphQHbkK2U0Q3ulPJ
cmJyLcgsuH/4+ALkfh39E1MRyQKdXb6YQ5X5nQ+AqKL5AbygWebw6TZeTK2wUWRs
GQYbFtjFvuMvOvtNV9m6uh+WdMl/UvmOmAEp5es7RZz5yFVbcQJWEWUbj2hsxsp8
OSUiWh+zJbCQEV2QsMiiXNWSUnnY8FruYsimN14hKpM7+Rbk17RJmgk6gGQO71Ma
ho3m7LJghYGwNZHw5XsA
=197Y
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
