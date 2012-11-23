Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2KWOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:06:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab2KWOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:06:49 -0500
Date: Fri, 23 Nov 2012 23:06:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ola LILJA2 <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Initialise PCM from MSP probe rather
 than as a device
Message-ID: <20121123140643.GO4529@opensource.wolfsonmicro.com>
References: <1353675941-7303-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X35wERi4JU/f1kly"
Content-Disposition: inline
In-Reply-To: <1353675941-7303-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X35wERi4JU/f1kly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 23, 2012 at 01:05:41PM +0000, Lee Jones wrote:
> The PCM is a pseudo-device. It doesn't have any of it's own registers
> or hardware. It rather acts as a layer of abstraction for DMA
> transfers. Hence, instead of classifying it as a device in its own
> right, we call the initialisation from the MSP driver.

Applied, thanks.  Please always submit patches against the latest
development versions of code.

--X35wERi4JU/f1kly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr4LhAAoJELSic+t+oim9AOUQAIDw7765BwXMVDpZKROK8pIn
c1P2mTrCt/e+sE5n7PKDEk8bw48Ub0cgjqZ/iBGIVOoM/L8YTBV5+i0kGw6/1qkT
dt+xoDePAKDYxdiRpVNggsa7OUIM53VHxOKSuIqAfhqQmBB4kCzB+KRQ4OQornVQ
ql9pjulsjsNYXRxNqRTPGInTameVQjxX/rZOX4IXWkZs2CuyxNFz/jTMdgIqkSP/
Pukt7GojmwP5gsAoQSTUCoZZhOJ7gUWuN9zVJsopoN+Dk29k6DKU6QzYECcXyBPf
wqmMXOGy/wWOOjAuesXO7YCl5rre76I1h4k1XvCdqfwaQQzj+pFR4FsKJjMWkOgv
d70HI2XkQrbjgDoAwMyiyCT9UJeqdx1/gD18KCmvbzQo4MgDBLuYD+7+2bOg5Vuc
PzbgqoYZyNy9tJ22DxFvGGKxoIfVFpeQ83pMRQzPuj2ClLIfpvtZCSFlrdDbCvbx
ixHxRBQFAoDhKaexlpNAqAvt2u3SnyIfCCEbfqtTCZazITQQpxuEBk/jFWAmfDAS
vi8W18wMf0HYzOZiHi+JYh/hhJZ1YrhF7wDEKY7pBLqmA/SDDOkWPlc26RB4JDYF
52rFuWmS4xqaubvy26Z3ON8mRqoenqJcmTER7ISPTM+QRekFi03rsYaGr1m5tQq7
L8UIiEYwQ/w2DiY7qk+Y
=803T
-----END PGP SIGNATURE-----

--X35wERi4JU/f1kly--
