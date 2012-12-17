Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2LQOPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:15:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab2LQOPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:15:39 -0500
Date: Mon, 17 Dec 2012 14:15:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Paolo Pisati <paolo.pisati@canonical.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121217141536.GF4985@opensource.wolfsonmicro.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
 <20121213094715.GA1916@arwen.pp.htv.fi>
 <20121214153943.GA3306@luxor.wired.org>
 <20121214154030.GD18233@arwen.pp.htv.fi>
 <20121215141519.GA22033@opensource.wolfsonmicro.com>
 <20121215145738.GB15606@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
Content-Disposition: inline
In-Reply-To: <20121215145738.GB15606@arwen.pp.htv.fi>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 15, 2012 at 04:57:38PM +0200, Felipe Balbi wrote:
> On Sat, Dec 15, 2012 at 11:15:20PM +0900, Mark Brown wrote:

> > It's perfectly OK to omit this unless there's an awareness that the
> > backport won't work on some kernels.

> that's not what Greg says, but fair enough. Won't discuss it...

Uh, no.  Think about this for a minute - we want bug fixes backporting,
we don't want to be putting process blockers in the way of that
especially not in the cases where fixes apply to all the stable kernels
that are currently active.

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzyjAAAoJELSic+t+oim9Bu4P/AudxLg/3n0cF4nhx6zREVUu
T83oRAT3aIsk3V2GTkbNdwyJOG9B9yfZh++rKt2Rn8auT+Uulay9z0A272u0WY05
cp8wRwqaCpvDwake1TqM9Gv0HtQT1lhx8r7bv2gsbzIsCT4zSt44N50Yt3gZd+Xl
OlGfj4goFN6t+hFMzjS7zRlgH+WS2vxbcyrIw5hcfuKIpUFoL57kTuveD/BK9lv3
nLZWDHyNo/Myg843jGJ91y1rjaqoFwuIm4wGbfq3QZEYwV7XXfXVZKnga6fCfKiF
GvVJnZDA4N6N97/R1ebhornKhUsb5MLmZYPx3Fx0pfcwNj8csfT/LfVX1qW9k6wh
O3/noulqpl179hCM5OQYUEFw+MNCCojuUQ4K62VbxxWHaMbRNaz9j3cwwBUlucBX
JTu7sU7/y14Nj8xvCWojsDU2ppCwONDAJl2OlHJ6aNgiqftTH7oyHYEqyYJ1fPuk
MccqEDzT1s1rw+/p1w7mQFNy+ucpANxz4zu5jntVVS20HoGRP9VhHyFfiFq/DIsm
hZOrVoBhEnRI0a8kyIUv2YLItA9GOEM0DCdGGWOy02UlUNoYsQzoRFxrN8T/G5oj
3XMQPIirPrOD4Ylw7QxXRhDeT5n8Xz8tDsgsnlPLHcycuiGs40jFc+8vSrV485qQ
GU+CMIzMvnpUsEH8W7US
=HHB+
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
