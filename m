Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2IGNRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:17:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2IGNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:17:52 -0400
Date: Fri, 7 Sep 2012 15:17:48 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: Move TWL6030 PWM driver to PWM framework
Message-ID: <20120907131748.GE29340@avionic-0098.mockup.avionic-design.de>
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de>
 <1346582458-7890-3-git-send-email-thierry.reding@avionic-design.de>
 <5044671F.2030303@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Content-Disposition: inline
In-Reply-To: <5044671F.2030303@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:RxdhdLezBhi4dXO3SAoWrdqhDu+wgf35KIeieaLAtet
 6irDillafOhFECscx4KHKBvLWkJVGVFz3IqfA2tbFruaB3Bj0w
 nKaGAwFur0jnyaALfbwiHAeoDfGcqRIayQfZX4jV1LmxCrv/MI
 YX56BwKsDm6+Zox/DtSnPJ64QO3g9zYNAry5qk+ujkpuodxopy
 ujvl8moF6v2sE1WRm/Lul6AShxocwcaiXrYjgffY9awLD4Rurs
 emo20Wk6a+4eJjjvWel+vOmKBHPXwIaGiZD2z7cdV7XZpAPW7P
 du5s0wbGlHzRAH3CLRlh0S2nLBjD05UM7AlStwYv+BYbZHjW6P
 bB7lU/PWSIOzk6SLR3kEgsBr5hSxURMUBthRWJHhPQuhgt+9cD
 4iOYpjCPvGwR2J6mknzkASI5p4cJX57bQ+wxX79s9cucM1WUE9
 2smHX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 11:15:27AM +0300, Peter Ujfalusi wrote:
> On 09/02/2012 01:40 PM, Thierry Reding wrote:
> > diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> > index 5fbb2a6..1b1a789 100644
> > --- a/drivers/mfd/twl-core.c
> > +++ b/drivers/mfd/twl-core.c
> > @@ -638,6 +638,13 @@ add_children(struct twl4030_platform_data *pdata, =
unsigned irq_base,
> >  			return PTR_ERR(child);
> >  	}
> > =20
> > +	if (IS_ENABLED(CONFIG_PWM_TWL6030)) {
>=20
> I think you should also check for the PMIC versions here before adding th=
e child:
> 	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
>=20
> To avoid loading the twl6030-pwm driver for twl4030 class.

Yes, that does make sense. I'll add it.

Thierry

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfP8AAoJEN0jrNd/PrOhFRcQAL537oXPOtAB86V/Kh2CNr1j
UWQukXx71cGkrZ7F+hjWf9nkVJ/Y7eQSZp1qSnTHWdm902H8nmALZtZbdM5FKM4E
51udSoTlNAQzoyQkpI8M/0dWjTvDhmWVNAqWSthlv7PWUXYJS35qzy7W8b2OvU2W
HhqXIPLNAmS1D9CBAmAheSORLxehMvIj6GtturDsMSgJRoHoEArJ9bvwFzMFZDpU
gkObx0zOStl2fAlhMR6VzBY6xeJd+NvaXh43c17DeYZEr+0uix8e2gCgW5NSOWvV
yHFX7h6AUbgV6aIYj4kxjR/KA9cI6pHeGgMoDLIm/m237NTquKCGWkWcOqliW7my
zIivfDsW1HRAO5TyYz+eGCXR6Q5jRM5qx00x7+lizHccpiOXHg5zaJT1JFLrV5z8
lSASnDXSA+vNIl8Z2qn4FojJqVADsF6+EF/AfiYC0M3l27y5/sMkzxAeGp1XKoYu
WB7b26JCjw8GJTNz1hjpEv7jM2La3DPSJmUN3g/rFIpjGhHqbLeJ7AdzsILo10zb
Kt3VbDpU8CSXwpdOQ+JJGz1b421PlMMkKI/E+4+MNUw6fL0al+ZQpzlm7lFHpzC+
zgdx3P65OfasNgPCFwnTq3iHjedb6Q8F+PkZpF3PUxGGPoeDF4hMevSr+vnC7sjH
63Ku8xZHwpugWZE/fsI7
=RwlL
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
