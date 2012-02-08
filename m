Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2BHLD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:03:27 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55799 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756861Ab2BHLDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:03:24 -0500
Date: Wed, 8 Feb 2012 13:03:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 3.3] OMAP4: PRM: fix build breakage when CONFIG_OF is not
 defined
Message-ID: <20120208110318.GC16334@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328698752-18756-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Content-Disposition: inline
In-Reply-To: <1328698752-18756-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2012 at 12:59:12PM +0200, Luciano Coelho wrote:
> Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:
>=20
> arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared h=
ere (not in a function)
> make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1
>=20
> This is because of a missing include, which is added indirectly if
> CONFIG_OF is defined.  This problem was introduced in commit
> 2f31b51659c2d8315ea2888ba5b93076febe672b

same as previous patch. Abbreviated commit and commit subject.

> Cc: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/mach-omap2/prm44xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
> index 33dd655..f2e06ad 100644
> --- a/arch/arm/mach-omap2/prm44xx.c
> +++ b/arch/arm/mach-omap2/prm44xx.c
> @@ -20,6 +20,7 @@
>  #include "common.h"
>  #include <plat/cpu.h>
>  #include <plat/prcm.h>
> +#include <plat/irqs.h>
> =20
>  #include "vp.h"
>  #include "prm44xx.h"
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMlZ2AAoJEIaOsuA1yqRE+nwP/j+ZK2fHlDPcVJocqYtNObln
CUFW0swuFshJ8PGfsNvyll3Tif6KfZtj8XHDGIBks8ZM0SGjkXMjhU5TvMJ+Gy95
j5iZWiq7lKlE+SKbcCnHfKgyQtE27jYtjr7vCwZLHInR8xRvJ04XgIw2nuOEBtOt
9z95MfEV+FtHWLY6qWUF3/vuMnPLS9aOLjMQ618eC7s7ywBFJL8JhTEh7H8xjGyS
T8vibZkHNtSEFCqjgOxPOq8wi3kNIDDaXH9r+ZfuazqydKgYogJ+BMY2sDixekOM
mK7uoHrTvsYm3SM/WOTo5/4OGAt9Ij6u9NFoN8TaGNyfYdz7E6u/Oadecyh6uqix
ytTuZU3vYDzpKpsGEDNkXzuPJHb8giu4cjMW5wgYyepSWwLHPxpCieEsh3+uTsAg
TqR4tE7Dl5/xgOpbhVL4Dq7MMhR7tfmBQj5tJPJ8f11uv6/RAzGlExjDCNYv/pCw
3I7AYlbtTkB+j34UZhE0pcldu7aggJBj95zz3eIsJswgudFGyQ7Sa334r7tdF8An
Dp239u7KiOPc8i6NDPLPULu5F9RgEjtxpyzkIm3fXL0hm7LCeCogcLgz1WX5/ly9
2BJB1eABq7IFmg7Y/mwQXW/0YvzGfYfCa5xN3oSdhxP1u6r8ZxMIyRa7y9nQO+JS
tWBqBtGHH3voCLwOjeBg
=1zJ1
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
