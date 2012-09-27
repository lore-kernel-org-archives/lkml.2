Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab2I0Hpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:45:42 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:56796 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807Ab2I0Hpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:45:39 -0400
Date: Thu, 27 Sep 2012 10:40:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 1/7] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20120927074039.GH12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
Content-Disposition: inline
In-Reply-To: <1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 10:31:55AM +0300, Andy Shevchenko wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>=20

commit log would be great.

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c4b0eb3..0b88ced 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1700,6 +1700,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
> =20
>  static struct platform_driver dw_driver =3D {
> +	.probe		=3D dw_probe,

probe's in __init section. This is wrong. You need to change probe
__devinit.

>  	.remove		=3D __devexit_p(dw_remove),
>  	.shutdown	=3D dw_shutdown,
>  	.driver =3D {
> @@ -1709,17 +1710,7 @@ static struct platform_driver dw_driver =3D {
>  	},
>  };
> =20
> -static int __init dw_init(void)
> -{
> -	return platform_driver_probe(&dw_driver, dw_probe);
> -}
> -subsys_initcall(dw_init);
> -
> -static void __exit dw_exit(void)
> -{
> -	platform_driver_unregister(&dw_driver);
> -}
> -module_exit(dw_exit);
> +module_platform_driver(dw_driver);
> =20
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAL3AAoJEIaOsuA1yqREorUP/2z6f1bQ0dJWGfQehEkHsyKp
Htb7H9T6iXcjYr72Lpey+4lqKmZ65yI+yf4PjRa/Wdd+HocB3TsSkB3nexpBmZeD
QAhJSu30444lEobWe9AO21rZDVQIN+WTKjkE0TL/VFEmN0gd7yn7TbZx+24cSid/
2YrOV1rSZoBX3hz5+WY05gXHc6mDUeZBOHuU8zuxnFzjYT/5KS4Lfwka97Zo77Tf
iw9PYy3A6rrSN4V0TzmPr0KRJROubITOnadgcSh/EJvviuL4oWFLmr5mB978Wq9/
0zvGHiLIKSCtZOvSOYhmjxEN+FLTejgW9yw/P4xiWbyxrM/QBQBWn6uP/GAXQRh0
b/VS0e104vXh4qu/z3gF+cVyHp9ZvZIUXIRH2tmcI+otG2edRhffIFcGSc9PYWVW
3t49cvLccrUY35y83mjyLN4uQq83AdCwb/L0/PCFJ5SVvDTlxLJ5Hiu0GTCr6lMU
JFdv7N83q+yiXXUmk0owVrg9jQ8QeiM/CxR10C0AEKu8JK110m8FCZFqIFbpsKXm
OSc2qyZUMcbvgUhAhuvWeIQGxmyKkaD07CANpwH12BsGvr4QK9h3Y5hkG3RQxafp
jBxBZ890D0gpKTI7tiPtKrgSMPfkbyAza0sME6wTlB1kChemFx5KNXXVhNsI7Lyp
iYenk4NKSEuCp2wc9W+Y
=U9mV
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
