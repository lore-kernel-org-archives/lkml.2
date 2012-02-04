Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2BDRV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:21:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43744 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab2BDRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:21:24 -0500
Date: Sat, 4 Feb 2012 17:21:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Message-ID: <20120204172119.GF8042@opensource.wolfsonmicro.com>
References: <1328370879-18523-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120204170632.GA3615@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <20120204170632.GA3615@merkur.ravnborg.org>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 04, 2012 at 06:06:32PM +0100, Sam Ravnborg wrote:

> There is an even simpler solution.

> For each arch that uses asm-generic/gpio.h add a line
> to arch/$ARCH/include/asm/Kbuild like this:

>     generic-y += gpio.h

> This will then make this arch pick up the asm-generic version when
> you do #include <asm/gpio.h>.

> And you avoid the kconfig games.

Hrm, that would work but it does mean we still need to go round and
manually enable GPIO support on all architectures which is what I had
been trying to get away from.  It is a lot simpler though so it should
be much easier to persuade the architecture maintainers to do that.

--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLWkJAAoJEBus8iNuMP3dTScP/i6Yc7ptakuyKbKi5j+iVa1s
i6ySBMtkLmgcj1bHdwDBjfFp93c7IMqhKRXFNw4zYcud5dOkOPLEMajOQhv1Tlag
Mdc1QNjxW7DFCLYAwcWi3aMrWRglq+fYz0iqz+EhMeDstFK3kZLYpDPyYH8dAGSY
uifbi4XIil4sLtWvKy8WDcccxhOAdZt443XatGY6VekmsiNBvEvbrW27cQbR6QOV
Zw21nrqMIHF1t2MWsMWCFpQX5ZAeg4CFb/E3csaKWwc0QE6f717P/28TQUO704L1
Gvv8Jpt4cpxTJkd590jW2VVg9mCWTi2DynTBMEO0yyvtwIGtK2NeFjwZTi5Nqgh2
0bihITOW3xTYaJYDnpydNI1tpIr+mqxlEi8WDEnnCdB5T9MUPSmB0QdVJyoTO2eg
tBghAVG1YyjVamsRtZAnMO70ysEsphvQK+h086z8+8veyzl76+iMQryr8onRYO9O
gzqD7NZyT2/c+XKBnwOrDbBUWho3HmZtMp2maoYwOwX+Eg6pXA/QoRBvMadReY+D
BvoCgXpT1R2YPfsTE4SOerW911chlqkwwgR/5NPOMieIY3z3L/ITNVzC61A5JajU
r1tzEwzhRwSNUPNZcMx1lPsXq72WvJbA3jH4yJ+XF37xpITVDp9x5WDkFET72CAp
nrOiab4BJ8JUs/fRUlTM
=oVcL
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
