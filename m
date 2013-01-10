Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3AJNdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:33:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50479 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033Ab3AJNdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:33:23 -0500
Date: Thu, 10 Jan 2013 13:33:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110133319.GT20956@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <2921304.SsX3sQo2BU@vostro.rjw.lan>
 <20130110125159.GQ20956@opensource.wolfsonmicro.com>
 <90529114.hOo9bzgA6o@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZXzThk3vFZecBD04"
Content-Disposition: inline
In-Reply-To: <90529114.hOo9bzgA6o@vostro.rjw.lan>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZXzThk3vFZecBD04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 02:18:08PM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 10, 2013 12:51:59 PM Mark Brown wrote:

> > Sounds sensible, yes - about what I'd expect.  Is it possible to match
> > on CPUID or similar information (given that this is all in the SoC)
> > instead of ACPI, that might be more robust I guess?

> This particular part may be present in different SoCs.

Right, but I'd expect you could enumerate the SoCs?  Someone might
decide to change the clock configuration for future SoCs anyway.

--ZXzThk3vFZecBD04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7sMXAAoJELSic+t+oim9QwcP/0oJ4b4baeb19ltrQPKPOvME
Lr8MShMY2kR/nPxmD2N1X10eg7XqOKjsflTaUdS8l2J/6SD2VbXrt0+ALCW1+Q/h
mQ1D9IMA+X/0irzVyRdU/joJl3WtB4q/VosRnU7UrkOA0QTXBmk+djaCGn2uI4f6
1JkiJVwarANVEOByrA1pt84eBoSV78c1ZeLh3yZakjQ5O5dEYbmJSzIfbrnVwJ3w
g3D1Yy0AINaNiLWrmkJWdJf83YbY+wx0JSxiP5tUM9vIgbVZrHKhX6kEhvHZpcxJ
q1fhmM8Pev4NOcvH11eyHMBWblkU49no6YW+7RXas/YKVE42bhmLFFWIa7+MoPXc
9ANT5csoJHOdTGakt3kfQR2AE0VFjPE/7VJstYTN994p1/kIp+qkMvYbhujGBoxa
KWuKWF5ngdRhTL8CgTnxSLHmfm8aXihVAykZFj5h57pt1eRKyw3a+15ouoX/JUlH
1nNKgKm1abPxT+Gk+/ZGygfFAr6M6mswJ77lDVeRPTod48cJ9BbqJnL7FemF805/
hduAKDKw/t71VYbNeXYiwkxah+mnL98t5fArZ09G8jj21mdGJgI76oGP55/oB3ac
MM0OVOh5cjnwi1kqHJa0S4thAV1JoJSdvugiclUkqZzOImTE7rCJBbVFU3+JHDko
x05HZ5T6T710nPzfsLbY
=kYpW
-----END PGP SIGNATURE-----

--ZXzThk3vFZecBD04--
