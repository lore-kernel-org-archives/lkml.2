Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2KMIs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:48:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:44490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab2KMIs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:48:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="asc'?scan'208";a="246200630"
Message-ID: <1352796571.2262.50.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 074/193] drivers/mtd/devices: remove CONFIG_EXPERIMENTAL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Weinberger <richard@nod.at>
Date: Tue, 13 Nov 2012 10:49:31 +0200
In-Reply-To: <CAGXu5jJ2XMB+hhzH0MFY3=tkF+iFY8srbKbvy6RMxdrnb0-FYA@mail.gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-75-git-send-email-keescook@chromium.org>
	 <1352734564.2262.7.camel@sauron.fi.intel.com>
	 <CAGXu5jJ2XMB+hhzH0MFY3=tkF+iFY8srbKbvy6RMxdrnb0-FYA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lJ5hmR0uYF361Cs0rR0F"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lJ5hmR0uYF361Cs0rR0F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-12 at 08:43 -0800, Kees Cook wrote:
> On Mon, Nov 12, 2012 at 7:36 AM, Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
> > On Tue, 2012-10-23 at 13:02 -0700, Kees Cook wrote:
> >> This config item has not carried much meaning for a while now and is
> >> almost always enabled by default. As agreed during the Linux kernel
> >> summit, remove it.
> >>
> >> CC: David Woodhouse <dwmw2@infradead.org>
> >> CC: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
> >> CC: Robert Jarzmik <robert.jarzmik@free.fr>
> >> CC: Fabio Estevam <fabio.estevam@freescale.com>
> >> CC: Richard Weinberger <richard@nod.at>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > Will this stuff be merged in one go or you want it to go via subsystems=
?
>=20
> Stephen Rothwell asked that subsystem maintainers carry the patches to
> make it easier to do merges, but in the cases where that's not
> possible or a maintainer would like me to carry it, I've been putting
> them into my linux-next tree. It's up to you; if you take it into your
> tree, I'll drop it from mine. Just let me know either way. :)

Ok, please, carry and merge them with the rest of your EXPERIMENTAL
removal patches.

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-lJ5hmR0uYF361Cs0rR0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQogmbAAoJECmIfjd9wqK0s34P+gJ6sFDEJJQ7Z4+DANZ8kuL0
osteBI3YD0f3d17HGuh+UszMI+tHk3fvmbmFPrSVkzVZsG6IYoXTce33Z44inZKK
pOHaDfKYQ7Nwvhsex849muJaoB/gjggEAS4Z2mLdJs4GSZoWyd6B2eJjVqhm4ckA
gOk5ecCgCswosfkr2GnmBmORICb9Q2dUJ1j/3oNtqIzlt602wdyjsIavKHuq2FOm
kHUP8xSlC26lrqA1fPXUW21nCs9pC96JbIuQRz0z/iObjBYm78WGymJZdrMUh61W
poB/Q083jX58Be56WYP8dv96/YnnZ7uawnIAVigTZM6/BMQnbcIeR4whRbuT7UY9
z9ImFP0ZSP0Uhz3SEoDVm2+DhUPgOPvWBXQ3zr15u+d85fPdSgbZY6m3GdMJ8tOm
v2zy/uPs+6qxK1iP9jiRwC9x351orVJ1lr9Yf5A9B0DIquj0N3uV4ieWYR1W8liz
MoVTIxrn1lLabGrlYL/M6f2tkDGK4r7tORqcXJoch5i+SiSLDmf1CleBM9YpaPE0
WdwOE1lAJxaIUS8unmCDshRzM1BS6mqmSSxz3xSg5NwO3RxRYbGbxa1/HiZvyNoo
v3DJv0SPeM2kcxHK4yH0aiDZE1ZgrALE9ZCSwFyF3Y92eoKu73jGJ2538wYX/Jcc
nYAw+dRvD9jQu5nUiDqF
=XS7J
-----END PGP SIGNATURE-----

--=-lJ5hmR0uYF361Cs0rR0F--

