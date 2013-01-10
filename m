Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3AJM4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:56:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40521 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221Ab3AJM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:56:04 -0500
Date: Thu, 10 Jan 2013 12:56:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: max8998: Ensure enough delay time for
 max8998_set_voltage_buck_time_sel
Message-ID: <20130110125601.GR20956@opensource.wolfsonmicro.com>
References: <1357731297.5239.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ECF1u7dKBoUGhe3"
Content-Disposition: inline
In-Reply-To: <1357731297.5239.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ECF1u7dKBoUGhe3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 09, 2013 at 07:34:57PM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP to prevent truncation by integer division issue.
> This ensures we return enough delay time.

Applied, thanks.

--4ECF1u7dKBoUGhe3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rpBAAoJELSic+t+oim9bX4P/3QHyDYTjfbgSWkG4pwsyjNp
YY8IBxfp6yR3Xqgo6+oRs9ZjTH0X6XB8AR9ZVm7BzMqKs6eAAMlK+OJ6NWaIwZID
L3on0akrwmgKLBJiAsfYgy2nTA0jY+ru57Cx8aamkuKkAHnDHPo88UiWsPBxULJ5
el5g/TJVQl8p3V0dQTfY6Jmylj0psSnX+7iRDzua+L9RzkFt6Goc9vLikUAuKQCh
rA0OOCHwEu5BN6Am7rUbcJhL3B9Hac0DGUB5ZRUcDe/DGVkHpI/JxylM053K0Nve
zg64UFEWUfnWjy2sdiA63V53A4vO6iOnwu8IBIQHB4HICgjhGhb8c94Ytj0zT6zA
Yvzt172o1nR7Ob6okjaEiQNUzxtizGHhMbA3Rn2RxsoCCQnu9LlgdlxZi5qPcjmE
tV6nrgq58rzwdAwAVZK54ORM5X/txEC9L+HquCVAoabm3T8l9dg4EwL1LAWwHQX8
5hJ4nKCSy2MscMmtJGwNS0EAza+OvTvo+YMkM2+ExExUpKDA75wNiyndytPP5MBs
MaIXXz70TRItIY+8FJc2IQsKZzm3kUN7R1IVUNwWSdDLoeV0McnGY5Q0drvgsuU1
gbxIhlEEr9tTn0ioKXl+XpQ56S9bLgjQT3lbcW/XiQQaiHQrkd3DTJwCjiRTZUVK
+sw4xJhYC4HIUktozSz6
=yX4u
-----END PGP SIGNATURE-----

--4ECF1u7dKBoUGhe3--
