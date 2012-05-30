Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2E3MPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:15:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53742 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2E3MPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:15:49 -0400
Date: Wed, 30 May 2012 13:15:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120530121547.GJ9947@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
 <20120530100302.GD9947@opensource.wolfsonmicro.com>
 <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Content-Disposition: inline
In-Reply-To: <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2012 at 07:40:49PM +0800, Lee Jones wrote:
> On May 30, 2012 6:03 PM, "Mark Brown" <broonie@opensource.wolfsonmicro.com>

> > If we are changing the names then not including the ab8500 bit would
> > seem more idiomatic - we've already worked out which chip this is by the
> > time we're looking here.

> No, Linus had the wrong end of the stick. I've just spoken to him in person.

> Those are not the names of the regulators. They're the names of the Device
> Tree nodes. The regulator names shall remain the same.

Fair enough.  My point about the ab8500_ bit still stands though.

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxg9rAAoJEBus8iNuMP3dECIQAJy09zl91NR83uW+LMlYFWk7
9qXbqaEEwyBBzCW5JQjIbCJNmej33+FK7WIK2K6wn8OS5VogRB+ayvH+eVX+2VyB
Mt2nSk/1BUwgcm9Yb1G/lDfcWinSBGgu2C5tuVoe6pV6PmckXRW46vwxOBbIP0cT
rq1QQKohZpWRchorhjVuTvD7k5bELGWqt62BsUioyv92vizj4ZAxQYGg0nssShqM
x8nn8Ygjibm1WvOlIH3Tl8HvjiLQIy/aJDRmDgAq/UmZAYlGKN1IXS/ggRJ44VlU
KgP7uBkY1YuhWrIuFe4OCDgS6VykTweq+4vwnrcS1iPQ+dYfhgXbrKq/W5kK33PT
NFPuNxip8M3PahW5BBKIZRCiIRLX5AkaL/8j6+ek8i8jApGSOlDzpnlXosyVvDsk
CLEZya8XrLKWSOnQLRI8zNx+TCC89L7UBSLFEDe9yUEC6QUHsMBdkYCffzI6+P2d
n5RQp4YyQcCT8ArGT9Fbm5pPHT8Lm8oqgCNUuxmwWBUYqfMAVN9v6keWK/mkmQ89
BQLYTKqVeQwENZjV+k7riY2XmN//oKWh7O0HBriwA5RLu1tyGmFOHUlEqRlZGLCH
x/heGYmw9s3xJ3WkWPhTi1cOZrDNdY9y7MDrekTPBDAM/pJatRzO9KxooHmQ1oYG
7BJ04B0lsbUrcolPkINu
=AhJ2
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
