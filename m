Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2ENQgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:36:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab2ENQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:36:11 -0400
Date: Mon, 14 May 2012 17:36:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps62360: Fix build error due to missing
 semicolon
Message-ID: <20120514163609.GA25668@opensource.wolfsonmicro.com>
References: <1337011088.6054.0.camel@phoenix>
 <4FB12EA3.504@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <4FB12EA3.504@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 09:41:15PM +0530, Laxman Dewangan wrote:
> On Monday 14 May 2012 09:28 PM, Axel Lin wrote:
> >Fix below build error:
> >   CC [M]  drivers/regulator/tps62360-regulator.o
> >drivers/regulator/tps62360-regulator.c:351:1: error: expected ',' or ';' before 'extern'

> Really strange!! I am not getting this compilation error in my build.

> Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

I suspect it's due to a CONFIG_OF difference.  Applied, thanks.  Are you
OK with Axel's patches to rc5t583?  I'd been holing off on them for your
review.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsTRoAAoJEBus8iNuMP3dYHoP/2M412ibkNp10xGLg57Bt8gl
Brk3lNzDnKM9twCgV41pl8ktpr51/k2wKr2lnGwWj/Dis4lWBzPAOeueVhvv8QHf
Sp02Hc5Vzh80OuUaAPJxD4MnvQQhP7MyMQz32iTA6M/IY209fgo4lgVIbd9G5AXz
r7g/PWGeS39liJleZI3a+0o123hY7e37+PSXISMpYjJAH+GrbSEzeb538NV+y36K
AcU4jSFb6M2qImnuMKsPtclm+E128V4c4yk/YgVK7pHz4aR/puzSdVpccQlVxJbv
yLuhpxWKqXqv3Rk/+0eMqumBgXTgYL7V23Cz/PSQWccSvMmgwYtWLXTLH3o/2rIy
KeIHjAlz7b9ldzZHJ+0rvdIULorK1lk5EHlUmf30Q9zGaHnrq9lFYjvzIS3wXGBg
cVF2nAiRrq5l109okpakoATgJtHvtB+3DabNdfnHM5LmN+Ub7O7MFJtwhZj0rJmt
JKALM1BbWgjF8qrqDY1/QlNixxP6YTIPADoCDa4kI3Rc19wKtpwKWt6mkfbMXzfZ
AvsLZVF8gB4ck4ZrW14M3+gk2TwO+5pqk+zFAWqluQ86riHKKjFke8gWorjYXQVI
84WpCu7HW2sqdgZn4j1xzJeTRQ72hIrx84Al0lAPFopcY8WS/0Qa1qBZixdtADQr
08MNEM/sMijVqDw+002O
=GBIR
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
