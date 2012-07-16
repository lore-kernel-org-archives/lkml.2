Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2GPLSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:18:55 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:47396 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab2GPLSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:18:53 -0400
Date: Mon, 16 Jul 2012 14:15:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, Felipe Balbi <balbi@ti.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/8] usb: Use eth_random_addr
Message-ID: <20120716111556.GB4913@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1342157022.git.joe@perches.com>
 <4759c60545463ec0867195792dc5f42f309ed6f0.1342157022.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <4759c60545463ec0867195792dc5f42f309ed6f0.1342157022.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 12, 2012 at 10:33:11PM -0700, Joe Perches wrote:
> Convert the existing uses of random_ether_addr to
> the new eth_random_addr.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

for drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/atm/xusbatm.c    |    4 ++--
>  drivers/usb/gadget/u_ether.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
> index 14ec9f0..b3b1bb7 100644
> --- a/drivers/usb/atm/xusbatm.c
> +++ b/drivers/usb/atm/xusbatm.c
> @@ -20,7 +20,7 @@
>   ***********************************************************************=
*******/
> =20
>  #include <linux/module.h>
> -#include <linux/etherdevice.h>		/* for random_ether_addr() */
> +#include <linux/etherdevice.h>		/* for eth_random_addr() */
> =20
>  #include "usbatm.h"
> =20
> @@ -163,7 +163,7 @@ static int xusbatm_atm_start(struct usbatm_data *usba=
tm,
>  	atm_dbg(usbatm, "%s entered\n", __func__);
> =20
>  	/* use random MAC as we've no way to get it from the device */
> -	random_ether_addr(atm_dev->esi);
> +	eth_random_addr(atm_dev->esi);
> =20
>  	return 0;
>  }
> diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
> index 47cf48b..b9e1925 100644
> --- a/drivers/usb/gadget/u_ether.c
> +++ b/drivers/usb/gadget/u_ether.c
> @@ -724,7 +724,7 @@ static int get_ether_addr(const char *str, u8 *dev_ad=
dr)
>  		if (is_valid_ether_addr(dev_addr))
>  			return 0;
>  	}
> -	random_ether_addr(dev_addr);
> +	eth_random_addr(dev_addr);
>  	return 1;
>  }
> =20
> --=20
> 1.7.8.111.gad25c.dirty
>=20

--=20
balbi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQA/fsAAoJEIaOsuA1yqRENCgP/3syPudQN8osRI5XQ6by6uJL
SDRYwXR9+mhKIFn6q0b0jrXiMErxEJ6Fia6c9hi0yXesI2V1Sblu8Qm0JRyxC76U
dxJrVYyHMhixqS+fY+ba71g/vw/KarO3tXiol+4z04+T1hH3OmZpsmCSfiRGswED
g4+dHEt4LB3gmioR8QYxTmw9JGt5hYXjrEHNOckjpos1rIDRj3lWhxwYxe1D4QPT
4i31goAPw/AtzqmX/xUjIrHD6D3QgI/d7IFhzo0PI71AM4iyzog1oZMri9h9UZ8q
dmrtnIUrEKACLKWiRsAns5itZFZ76Y5d/pVS/aCRxFcdoIm0S/nesaG1tE4AOPz9
xC/anwElRSzJO3k5wxW4X1OUnoIFFabqrSfPPSfEpouZeA9gLWGha+NQ1eQHA6NL
TiRTvwgAvrMgfsy3u/mrap0OKVtYm7xoxiY632++PRGRyoeQDU4FFtfF7D9rOoof
lQc33Z1pd9btNA2V0VenV6/GJxvg0w2qmShOXcYVk5s+VGdC2ahVensjpUQSGryq
zuLQBzGQWZ7u4HZ93TSBISft0rihFFdNpB0qhCahl2pIrYT77DqhPo017jTeMKPG
sZE9Gg/AB2fInzFk+NTFGmAgO3ICKOlF8aFFr/TTAPoWSSeI/xfutFRWGGkrIpJH
/t86gD4mefdajITYi9vZ
=vTRX
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
