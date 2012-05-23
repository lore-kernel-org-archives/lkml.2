Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2EWKDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:03:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793Ab2EWKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:03:50 -0400
Date: Wed, 23 May 2012 11:03:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 2/3] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120523100347.GF4085@opensource.wolfsonmicro.com>
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
 <20120520155616.GB9337@opensource.wolfsonmicro.com>
 <4FB9EFBB.20306@samsung.com>
 <20120521095540.GA1999@opensource.wolfsonmicro.com>
 <4FBC320C.2040803@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eVzOFob/8UvintSX"
Content-Disposition: inline
In-Reply-To: <4FBC320C.2040803@samsung.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eVzOFob/8UvintSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 09:40:44AM +0900, jonghwa3.lee@samsung.com wrote:

> I tried to change API to generic version but it got problem because of
> overlapping. As you know almost of boards uses private clock API not
> generic. So how do you think can i test it without modifying board file?
> I'm afraid of changing all clock registering is too expensive.

I've been using x86 to do build tests, though it's not so useful for
testing and you do need to enable the API since the x86 maintainers have
been ignoring my patches to do so.  The other option would be to just
drop the support for the clock enables until the clock API is available
on a paltform you have.

--eVzOFob/8UvintSX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLX0AAoJEBus8iNuMP3dwOAP/3rwK7jVFZhU6/xVrdjgvSGx
H/ZTs/lqwn0XfxegHeTzYCO/91lFvQMzfQBDSrtEY3EkLyNm4noMjoRvvY0Ao4Sl
DMEKzJ4SjeWTR707rXTS4xG9xbfc+bokSZhjVisu7Fquanv2qv64S4VgCrqpgYD2
Pqo9y8OhnzippCOZF5CbIrEyOAfZQH4YIeKYEEtxgOuZqbYDLzSXgxFsPGEbmXSO
MStjdWmSb1GwnOE0PM8lt9Jpjo0pl3HChahc3WYIS2GzftfkDAngi8pD3KEI7aCe
ZKOWLIH8rj9y/yZFlH4YGrk4kkwTPJ/n/myktpw8ly83fLbMPmvB/H2Hy/1RK4Z3
ru5FR64/+uwgsCzhfLtNeoKL6yoorachnH5CS3ezBd/zjUT3s2qjDnSEiAi4070P
QH7cBvTH34t75p63gaUYWmrEOYA8d/3W2UWL7lS9yop95w7q2RIY6DJy56E1u4Tf
8t6AD6QMunJffGtR34irVeDDNPIcv4nNod/5+d5PisfNT5kAKGF1rpn40tDOmPog
9obtljw+daBjwn80vQ6y/BWhaPjy+kYYIeuNi5v9qmBe9YlgNWeqInt01VPjp2d6
lpJP1nhDSkMoa1mDd7I1XvBU/H4W1XEA4tfx0b6C7pkbhLuqREq+XsyUVJj8Jl6C
TclBsVUk1X01JSNaCHku
=F0GD
-----END PGP SIGNATURE-----

--eVzOFob/8UvintSX--
