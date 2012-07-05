Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2GEMpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:45:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932531Ab2GEMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:45:51 -0400
Date: Thu, 5 Jul 2012 13:45:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705124549.GD4111@opensource.wolfsonmicro.com>
References: <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF2F82D.9080507@linaro.org>
 <20120703142123.GQ29030@opensource.wolfsonmicro.com>
 <4FF54406.3000307@linaro.org>
 <20120705094541.GK4111@opensource.wolfsonmicro.com>
 <4FF57EA9.7060107@linaro.org>
 <20120705120600.GT4111@opensource.wolfsonmicro.com>
 <4FF58571.2090807@linaro.org>
 <20120705122947.GY4111@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hZM3YBJafcqGfHn"
Content-Disposition: inline
In-Reply-To: <4FF58B68.5000703@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hZM3YBJafcqGfHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 01:41:12PM +0100, Lee Jones wrote:
> On 05/07/12 13:29, Mark Brown wrote:

> If DT is _not_ enabled, we do:

>   From platform code:
>    - Register the DB8500-PRCMU
>    - Register the AB8500

> So you see the registration is separate.

Right, so what I'm saying is that what I'd expect unless there's
something unusual going on is that you wouldn't be doing the separate
registration of the AB8500 here and would instead be passing the
platform data for the AB8500 through in the same way you pass the DT
data through.

DT and non-DT do have a very similar model for this stuff.

--+hZM3YBJafcqGfHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YxzAAoJEBus8iNuMP3d/sIP/2efdZbqjIt+cpQqnNPvk79/
HWyv1GBgP6LJ9MQAp42j9VOD0V1ZW7OKsnTnQgFpbMZp7F9XfYCKr0m1o8jJho58
hLcpssUABBuQ6K9uJgjE/3aE3E0VSAl3kOCdVG93lv0grapHaH/PSSxQiI+bVZq0
OSwAdzO3Z0JfJHTvviIjxsAksWWCK4uHY+2gs+wR9e7c8EikQKVkKUJo43qB2XdB
ZIyeXDgTz3F/56FcxAD+iP+7dfDz8jFFwueBur0fZbnF1Qw1S0wPA61Bym+Y3E3c
mWLx/zCUAZSMM8ZNc85bo+kXt79s4irIiNqybglrbTqz9NQErq7MTxBFp1LxRIs0
9t0ZoLOyKPc+KCU0oyjbewwU4VyvDdqd3FjXoZReXwNWag++WuSa2rNY8whyhtXW
wTOAXdF3cZa0AMIlONKdWer/uRkrftgwwTzZ7kFHef3X7wa5V5p5iCm6sQAsBWKV
F2py48Q9jVTIDKzIqnJlJ9fATXNn9wUdxK0te4KmFSiKcDDEZuq2aL64YCf7gbgO
1zYpgdj2XF/tnAdvlcPN4p/IzV/UUrHscJHQeCTAIxAMbjdJXRjrBdQ40OQ6O8Ps
PF6Pg62iTEH4XS5kc9Dv1TrlfGBsdEsrq6GS5LWQWWwyKye6COFM4OnBcAof1tOS
5Km5YSQexPZzq3MMUZbG
=c8CG
-----END PGP SIGNATURE-----

--+hZM3YBJafcqGfHn--
