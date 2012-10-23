Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2JWMpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:45:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44511 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab2JWMpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:45:12 -0400
Date: Tue, 23 Oct 2012 15:39:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
CC: Constantine Shulyupin <const@MakeLinux.com>, <gregkh@linuxfoundation.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
Message-ID: <20121023123927.GB29281@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
 <50868EED.7050909@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <50868EED.7050909@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 06:04:53PM +0530, Sekhar Nori wrote:
> On 10/8/2012 6:47 PM, Constantine Shulyupin wrote:
> > From: Constantine Shulyupin <const@MakeLinux.com>
> >=20
> > Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly=20
> > CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST=20
> > and set MUSB_OTG configuration by default
> > because this configuration options are removed from Kconfig.
> >=20
> > Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
>=20
> Queuing this patch for v3.8. Since the config options are removed there
> is no use having code which refers to them. The patch has been tested on
> DM644x and DM365 in both host and gadget mode (I will add this
> information to commit text while committing). Without this patch .mode
> seems to be defaulting to MUSB_UNDEFINED which I think is definitely wron=
g.

sorry for the delay, this looks ok:

Acked-by: Felipe Balbi <balbi@ti.com>

>=20
> Thanks,
> Sekhar
>=20
> > =20
> > ---
> >  arch/arm/mach-davinci/usb.c |    6 ------
> >  1 file changed, 6 deletions(-)
> >=20
> > diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> > index f77b953..34509ff 100644
> > --- a/arch/arm/mach-davinci/usb.c
> > +++ b/arch/arm/mach-davinci/usb.c
> > @@ -42,14 +42,8 @@ static struct musb_hdrc_config musb_config =3D {
> >  };
> > =20
> >  static struct musb_hdrc_platform_data usb_data =3D {
> > -#if defined(CONFIG_USB_MUSB_OTG)
> >  	/* OTG requires a Mini-AB connector */
> >  	.mode           =3D MUSB_OTG,
> > -#elif defined(CONFIG_USB_MUSB_PERIPHERAL)
> > -	.mode           =3D MUSB_PERIPHERAL,
> > -#elif defined(CONFIG_USB_MUSB_HOST)
> > -	.mode           =3D MUSB_HOST,
> > -#endif
> >  	.clock		=3D "usb",
> >  	.config		=3D &musb_config,
> >  };
> >=20

--=20
balbi

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQho//AAoJEIaOsuA1yqREMtIP/jdZ108B4IvH4f2+spApVsp7
3meE4I7BrIvNrWXvbeD81rx8ibr0h/dSxdZu8lVsOXTmNGT+u92U30o7Se8Dw+5V
lmmS1OJaXdDOyJ+aYY9UoKnTtkFwEZ2Ofp+JXyjwE3pfk/LcJXs7BCdEGp5keW4U
OnUb0dTDUE2ECNbjpN8tBIoMSe5tTlZmnf+VaTA8eOYAVS56X0K80pmZJpkRBSnN
dqqxLDQkE7LA9mzwGdq3+vFY2WfgxCmLQuGU5E4rFdWThz0I+LbIwRuXRg/Wl8iJ
7P2V9qbLRQqdYFkHW7tyCz3+vJH7+DTBbiJNGzZaAfWvtxpDSLThHGrwVf02OJpQ
RCDOLHco9wB8yK99V4fqQOa8qdZXWXJ1cQExZjdPh0aEjIYMDfSzTcoEhIC5zj7T
i0goQ3hCbcVLTOdhCdXYjeY7JtQ2PQuCbJtK8RfpY++eIDXznFJzFOYLe3XRGm+i
Q0U0z9NF2Ut6xqe+uxnRuLDcj4+mWTNiQzvY+Yo3x3xlKQuuYj0xJrAIeCgctgS8
34jntM4RhJMk6jJExEib0oYH5A+CNyVD2GQWSKvUsDUiXwIOQGeyHq0yc6xUQlSf
OGgB/2cJbKtcEALNZteBMEUrnYRgFSMHdIMFKQiPqv5lfcUqmZ7a1R557y6v0b8r
jgWsdA9VhkGR94VXuu48
=pb/D
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
