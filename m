Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DBRQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:16:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548Ab2DBRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:16:44 -0400
Date: Mon, 2 Apr 2012 18:16:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120402171641.GF15197@opensource.wolfsonmicro.com>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4F787392.5040308@codeaurora.org>
 <20120401153450.GC8971@opensource.wolfsonmicro.com>
 <4F79D85F.4020909@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <4F79D85F.4020909@codeaurora.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 09:48:31AM -0700, Stephen Boyd wrote:

> I hope we get a better clk_get() implementation with the unified struct
> clk. Don't get me wrong, clkdev is a great improvement over open coding
> clock framework stuff in each platform. But clkdev is really just
> another platform specific implementation that most platforms decide to
> use. Each platform has to select the option and it breaks if two

> Sticking devm_clk_get() into clkdev.c is simple, no new file, smaller
> diff. Great. But linking it to clkdev doesn't sound much better when
> we're trying to get rid of platform specific code and this code is
> entirely platform independent.

Why wouldn't we want to continue to use clkdev with the generic clock
framework?  There's nothing particularly wrong with clkdev and we need a
standard mechanism for doing this anyway.  Frankly I was very surprised
when I looked just now and realised that the generic framework doesn't
use it automatically, I might just send a patch for that...

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPed7zAAoJEBus8iNuMP3d1S8QAJiODs9T6yAZl3kc6Hw5dlEN
4W+1ep0jwT33T0Z+QAcTMHjSl32gUXWRPqeQX/5J4bT9lzpNBPxfXO07rLyxf5BM
2yMbeX+FZFIVk6HJs9Ti5XPs1/JSWYTehXhuKt6gU9jNE1DQnAKN7Fxn8MCXKHxG
DPSN38NaxP9KLdZnIMszuydHsO6pHTvmlmfaoEW61Be1w/i4/lYZMsXrqSfxGPfz
FpvJCL07m+wUT+kvSdQPGpMXgeZXNekj3nlzlUb0C+HTWipoqZAb6uD6+NrwqklH
LpLboz77AIyup3Gw48jZffGyrbmbHZWSXgzi+zf+CG4kd96CVmj9M1sDcmvQ5hMf
zu2AU6vkxFfM/TrASm3TmehMdJS0x69TadpV3N19Zb5Re+qr8na7+0F5S0W2mvVd
iRu2ObdgUFnvINV8BDH9esQK4/kFrNLcajvGqwFD/y3tlny+tXw3hgqWyedWi1ZH
EyRiGswuRI3w+CJcUSEGc8E9nrHe7ZmBc25evw5bhiGvPAmyhDZhZo0gp2aGS6I3
dBF19m3sG1NTMWg/IY+fa56I4ODabqcMpKhKkeQTNNrxSeQqFgDO02fUzjW6EGMv
WDHe8itnSFNkoXuiTH8BPMI+hlW51akMBft1FKi7G5LVZPcx1q0TIDlQYM0oOEP1
oksD5Ruh4F3h2nm8CHrX
=9n7o
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
