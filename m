Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2DWMKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:10:49 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52195 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2DWMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:10:48 -0400
Date: Mon, 23 Apr 2012 15:09:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120423120934.GZ26302@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
 <1335181043-15348-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/IQTGW+1SjCkQmn"
Content-Disposition: inline
In-Reply-To: <1335181043-15348-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/IQTGW+1SjCkQmn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 23, 2012 at 02:37:22PM +0300, Hiroshi DOYU wrote:
> diff --git a/arch/arm/mach-tegra/tegra-ahb.c b/arch/arm/mach-tegra/tegra-=
ahb.c
> index 411b51f..40877fa 100644
> --- a/arch/arm/mach-tegra/tegra-ahb.c
> +++ b/arch/arm/mach-tegra/tegra-ahb.c
> @@ -20,6 +20,7 @@
>   */
> =20
>  #include <linux/kernel.h>
> +#include <linux/module.h>

EXPORT_SYMBOL() is defined in <linux/export.h>

--=20
balbi

--W/IQTGW+1SjCkQmn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUZ+AAoJEIaOsuA1yqREkOMQALRrXLsnDqR32wYWocwo8LU4
4ahDTMw3SZt8NfLNDDhXZUQEhI7rJfq8ZFveLdnQ5k9T5Bq4dowUgaI9aMZWHOK1
s+uH2Ie5/TZLw6MC7++V9uIBn4T4XM9KLjiFNb/XUXdNOHJxWVlVXAe0udU9QaTF
14SGBNEZKaXI6gl0HfexrB9ehmHG9pEK5vVhHZupwKHeopYkTyAJb3TdNqmFXAji
/Hx1o4IReE/t1PJky5aodeLAMyXtz4bBgkLnXVMFPyKYQMxYp/AC1QbBuuon3Uj7
osEdtJC+aECG6UVIWe7OkQ0vegiCe5c3QjXBv7M7IBjSU2jAwVp32gUzbSaW9UX0
kVpL7B4oiSwKVLYPGwDAG8tit1GahNtrFUaFMfXp+H/Tdm/aznPtHwtMPpxGd1jn
5MWlJNS79QrQvFD0FcejN3IniYWZ7w0pgOl1I+lxpOiw94LudHGv036I5nz1b4b3
Cmgs9kqhcbl5Ord7Ym0twwdECCyMj9q5qzqGoXLRQqIf/KpRnbIjf+2GlEwlKUJr
tgbIL8A15yIm9tOJTMheO6Qn3Wg8VFUWFi+2VKprnLaI0KpoY8Fxe1SiyCTR2303
YnZ5xwW0pmvrniqCDZtyd4itExOScGwhEzy4FclTRJh0Dp/iCFsxtfeu6wEL498L
3I5CwVbiTv+aWDEjsX1U
=zB3M
-----END PGP SIGNATURE-----

--W/IQTGW+1SjCkQmn--
