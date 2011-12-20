Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1LTKm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:42:59 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59379 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1LTKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:42:50 -0500
Date: Tue, 20 Dec 2011 12:42:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 08/10] usb: gadget: remove useless dependency in config
Message-ID: <20111220104240.GA31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-9-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1324341747-5922-9-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 20, 2011 at 02:42:25AM +0200, Felipe Contreras wrote:
> USB_OTG_UTILS is already selected by NOP_USB_XCEIV.

did you mean it's selected by the isp1301 driver ?

> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/gadget/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 6207f1a..78fe02d 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -181,7 +181,6 @@ config USB_OMAP
>  	tristate "OMAP USB Device Controller"
>  	depends on ARCH_OMAP
>  	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
> -	select USB_OTG_UTILS if ARCH_OMAP
>  	help
>  	   Many Texas Instruments OMAP processors have flexible full
>  	   speed USB device controllers, with support for up to 30
> --=20
> 1.7.8.rc1.14.g248db
>=20

--=20
balbi

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8GagAAoJEIaOsuA1yqREUjIQAK2F6Qp4mQgUU/vVKNezqFXW
ogDUWcxNg19cC9zHEpdJVh5uF0BMMlos8cZNNXGJ4cZkCk+pZQhpV50A+MZpo8zW
fQj+pckEQz9yRaBHlb6WnrtzzJhT/GJIhGDguf5CAqIFDzIQCIlZ0KjLzUgMAvbU
tgkOBG17aI+26x2POS3jauQMokGsCLzjk/JSN7dT1LE5fGWhFQVHhQ8rhCwJlH/c
rQQU7Gi6pBRdoMKOY7gy5C/jUGyo0cvkdmtJdznbgORE/JHd5ov5SNEGC9I+QCLw
SAM72W7gVKxS06gpLwW5woa20JdRWx+RxCDTQWE9UyRFly3X168RDLPuX8tYdf5+
8ti5XYvkH1zAS/ceEepFZ1A+umKQN1KxkkZP/CRU3R/rRlKY1wD4JxPymq6k2oX9
fVhibAkG85HGk8n7N91GSrqI6IxyH1Z1LLOpgHCu8GtukPMsS8moX4DNG2eI9n73
Z/+WHoaYIj1VSwP+R5J8WQRyPPRjF7KB/V8cowCTw5IlYq4vFuxFlw/U5AHfjCGx
lDhI9dVJEoKZ3CBs45E/whCNYPeDzTmN8QdOZBsbqbU2suAGFB2OgjbrbCR0ZZhy
7Qdz9ft6CQkZU72b0PsYCvWEZeXuANF8mcqS4UEHRbU3UyW8dmS9uuhQkxrBV4+A
JqnQBh5tsSOo4Qp4aWGz
=7Adw
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
