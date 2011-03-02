Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1CBHbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:31:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40376 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1CBHbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:31:50 -0500
Date: Wed, 2 Mar 2011 18:31:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Jander <david.jander@protonic.nl>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        David Jander <david@protonic.nl>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?B?IlV3ZSAgS2xlaW5lLUvDtm5pZyI=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the mfd tree with the i.MX tree
Message-Id: <20110302183143.c52ecc00.sfr@canb.auug.org.au>
In-Reply-To: <20110301093528.00184f93@archvile>
References: <20110301145436.b1ae1923.sfr@canb.auug.org.au>
	<20110301093528.00184f93@archvile>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Mar_2011_18_31_43_+1100_WF553KFdv7I=scwV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Mar_2011_18_31_43_+1100_WF553KFdv7I=scwV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 1 Mar 2011 09:35:28 +0100 David Jander <david.jander@protonic.nl> w=
rote:
>
> Your fix seems correct, although I fear I am too dumb to understand why c=
ommit
> e84e545d47d26644275a79fe5ebc1797bcb80910 introduces this extra struct
> nesting.... AFAICS gcc will end up doing the same as without the extra ne=
st.

Thanks.

> Btw, include/linux/mfd/mc13783.h should end up disappearing after you're =
done
> merging... I hope so.

That file is still included by several others:

$ git grep -w mfd/mc13783.h
arch/arm/mach-imx/mach-mx27_3ds.c:#include <linux/mfd/mc13783.h>
arch/arm/mach-imx/mach-pcm038.c:#include <linux/mfd/mc13783.h>
arch/arm/mach-mx3/mach-mx31_3ds.c:#include <linux/mfd/mc13783.h>
arch/arm/mach-mx3/mach-mx31lilly.c:#include <linux/mfd/mc13783.h>
arch/arm/mach-mx3/mach-mx31lite.c:#include <linux/mfd/mc13783.h>
arch/arm/mach-mx3/mach-mx31moboard.c:#include <linux/mfd/mc13783.h>
drivers/hwmon/mc13783-adc.c:#include <linux/mfd/mc13783.h>
drivers/input/touchscreen/mc13783_ts.c:#include <linux/mfd/mc13783.h>
drivers/leds/leds-mc13783.c:#include <linux/mfd/mc13783.h>
drivers/mfd/mc13xxx-core.c:#include <linux/mfd/mc13783.h>
drivers/regulator/mc13783-regulator.c:#include <linux/mfd/mc13783.h>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Mar_2011_18_31_43_+1100_WF553KFdv7I=scwV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbfJfAAoJEDMEi1NhKgbsYI4H/0lPI1+IdZnEkV1U6/X9NfNc
TZE3SUmLYsi5P9ow62ffnDLuKiPCOvyiTKsYRzz3sPjLvFXMNzLmln7+VhWWbHi8
waQzObZrXg1n0N8oUMHLH9Dsb8LAlGEqxugbjz/NvVQZBLnAgSccwxg/q0YyLKHy
xJBUwX66gO89EO4egwPgvFg+lHxxTXtlFSDf18QoCeDLljpE3tOMssqv8Xnm6InZ
dX6WGx+yVLXCr08xK3ns7uDNj99MNrG9dxUFqs5IaXoMrd4ENqHPlJdi8Nuo+w09
aCBz7YCeQRmu2ZrxiAZc6arsdX19F2sMB3PTO09Cr01ktDcwOQ8L0cpm6pN+yjs=
=kwl7
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Mar_2011_18_31_43_+1100_WF553KFdv7I=scwV--
