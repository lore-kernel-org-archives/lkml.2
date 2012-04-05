Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2DEKeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:34:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983Ab2DEKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:34:07 -0400
Date: Thu, 5 Apr 2012 11:34:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Support set_voltage_time_sel for drivers
 implement set_voltage
Message-ID: <20120405103403.GJ3129@opensource.wolfsonmicro.com>
References: <1333506730.15318.2.camel@phoenix>
 <CAF+7xWmyPTCcTRjfH1QHZ2yGEXnt_PVrT3P3EqjDQAX0nY8Zgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWEb1MG/o7IKOlQF"
Content-Disposition: inline
In-Reply-To: <CAF+7xWmyPTCcTRjfH1QHZ2yGEXnt_PVrT3P3EqjDQAX0nY8Zgg@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bWEb1MG/o7IKOlQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 08:26:48PM +0800, Axel Lin wrote:

> I forgot to mention that s5m8767 needs this patch to work.
> s5m8767 implements set_voltage, get_voltage_sel and
> set_voltage_time_sel callbacks.

We should be fine without it usually, generally the ramp times are
relatively fast in comparison with the time taken for the physical I/O
to complete.

--bWEb1MG/o7IKOlQF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfXUTAAoJEBus8iNuMP3dA0sP/R43VnXZUbhHWZuGngGd4Tq0
X9msqBcotDV2j3qNn/ztyCadrK/MyQshEJBG7Oar24T+o8tMdFYU3ldYWtV1unaZ
jsu9Z7A9Upm6lsqMSbqxp15CUd9doS/U88mfEp0Q52yfgnTqod0yEL8HW4TaxjGg
fxBUXKYc1dAAWDChKfcTWOms5il67mkbv4ZHeo+daLVr16dkzphidKMh8Um9yCie
msdDKomiBgaf+H1Onrz2MpxxJ9+vkIlELNvbDhKz+WN863IUHUc3E3GQqETTnIGp
auiEulHE4s2kkxsDNDIUUCRiDQzQhuP25OrBURWxU7yjNQNALIaC8zfOzx2SwoTg
rzUwotQIM+N4jGT8ov/rgM+imJH1NASIGhtLk2/enA7lk0WTg84Pt9YZMwrGZWvy
8/B9ibS6M60KdG0Id/SzXXLgTnFe6Nad+q620oLB7gK+V+yFhdrl9mMNVzaDMjoE
5Us0j+NthGerdGeIBINeZFVqlLipLFvCYa8Euml2BucbczDV0F4UonBpbJ/j4Euv
VZHP7bq8qBS6wAnn/nXsRBZeWlWn9S2aUtcaktCTffcoQlVyOv1F1uWzv2IwUA4W
sqNNeK8njihmEC0Bnzf/RUnXMk7vNEZDf0yxM8f1ozwo/T0JPS+rbUNSdRODRFZI
xqCgoqW3oAzJz30x88Xu
=ZhEI
-----END PGP SIGNATURE-----

--bWEb1MG/o7IKOlQF--
