Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2IFRRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:17:30 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:59946 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab2IFRR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:17:27 -0400
Date: Thu, 6 Sep 2012 20:13:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, b-cousson@ti.com,
        tony@atomide.com, linux@arm.linux.org.uk, balbi@ti.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Message-ID: <20120906171301.GC17754@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com>
 <5048C2A2.2020104@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <5048C2A2.2020104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
>=20
>=20
> On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> > The mailbox register for usb otg in omap is present in control module.
> > On detection of any events VBUS or ID, this register should be written
> > to send the notification to musb core.
> >=20
> > Till we have a separate control module driver to write to control modul=
e,
> > omap2430 will handle the register writes to control module by itself. So
> > a new address space to represent this control module register is added
> > to usb_otg_hs.
> >=20
> > Cc: Benoit Cousson <b-cousson@ti.com>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach=
-omap2/omap_hwmod_44xx_data.c
> > index 242aee4..02341bc 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb=
_otg_hs_addrs[] =3D {
> >  		.pa_end		=3D 0x4a0ab003,
> >  		.flags		=3D ADDR_TYPE_RT
> >  	},
> > +	{
> > +		.pa_start	=3D 0x4a00233c,
> > +		.pa_end		=3D 0x4a00233f,
> > +		.flags		=3D ADDR_TYPE_RT
> > +	},
>=20
> I do not have any objection/comment here, but I believe this is control
> module address space required for USB module, right?
> I am not sure this is right way of accessing control module space.
> Actually Control Module Access required for drivers is one of the
> blocking issue we have currently.
>=20
> Also there was some effort put up by 'Konstantine' to convert Control
> module to MFD driver, I haven't seen any further update on it. But it
> would be good to check with him.

this was an agreement with Benoit since we already lost a couple merge
windows for this patchset. We agreed to wait until -rc4 for SCM driver
and if it wasn't ready, we'd go ahead with this and SCM author would fix
it up on a patch converting users to new SCM driver.

--=20
balbi

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSNmdAAoJEIaOsuA1yqREWOIP/Ah2073wtfbxi2AJtgI6VqGC
mjsDpMEWfoMJ4CfJGlcL8sQhGczVLY4vsgCSvvdlE5hp6s5PaX5XlzbQUuIQ2v0d
9wTEiK4IJVmhNsICbMrn0GxUUpsuYoZNEpiN1nJ9au6Yxbygjo28Bw5CGRhqPfnl
XulKaAzOtOqyHRvJ7v7yfplAaWhwYB4guAvxYQ3v+iTFYGv3V0KzH8LDOKPqDNbR
DbPzgM2qI4k1iuvX/tsc1/DOvm6L8giAlf4tJt7nIXoLgzy5qlox6nv278qygiWW
WLP9f/RSvMqNZSOhsEw6NmxfsLy3PYuULoIe4ngDOWB7UUHGhF7SWIZ7jSCtZFvJ
Czc47ZH6UXgIKHBQ4KOBuqjG1xpGtkRWpGstbk2qZmW3O6/iP88T61s2Bqe+81R0
lHuOmVzz64BxwSyFHRMQR6TJuFXFgsMZ9tgHISl9dznPh1vb9rXwr9kVGcWiMTpZ
6ohKIQZIRqx3cIwkkPqvoKbt7dSGKyBkYUekyp61XV33W41ZrCmJi8odQmwM9cge
IHWPUNgMERpJLYiMc8Cs1vpro9K6WqnT5mBHmfsuY/JtiGInTN7xIBhd5z991/vH
cGf2w6hBgJmLeOFVTiDTPLE+tPn/NQmZpfNeUlz6sLc+/EBAbCO/x3Zu6odKILcl
VhGyrpmqmgJHMSaug2OX
=cQHs
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
