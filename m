Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0IMRpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:45:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46322 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab0IMRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:45:09 -0400
Subject: Re: [PATCH] ACPI: sleep: init_set_sci_en_on_resume for Dell Studio
 155x
From: Kamal Mostafa <kamal@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Zhang Rui <rui.zhang@intel.com>
In-Reply-To: <201009131934.16027.rjw@sisk.pl>
References: <1272498183-6094-1-git-send-email-kamal@canonical.com>
	 <201009131934.16027.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-T2c2KkFcCcmIPY158cUY"
Date: Mon, 13 Sep 2010 10:44:59 -0700
Message-ID: <1284399899.31551.275.camel@fourier>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-T2c2KkFcCcmIPY158cUY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-09-13 at 19:34 +0200, Rafael J. Wysocki wrote:
> On Thursday, April 29, 2010, Kamal Mostafa wrote:
> > Add Dell Studio models (1558, 1557, 1555) to the 'set_sci_en_on_resume'
> > list to fix hang on resume.
> >=20
> > BugLink: http://bugs.launchpad.net/bugs/553498
>=20
> This check was removed by commit b6dacf63e9fb2e7a1369843d6cef332f76fca6a3
> (ACPI: Unconditionally set SCI_EN on resume), so the patch shouldn't be
> necessary.

That is correct Rafael.  I confirm that this Dell-specific patch is no
longer relevant.  Thanks,

 -Kamal


> Thanks,
> Rafael
>=20
>=20
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > Acked-by: Alex Chiang <achiang@canonical.com>
> > Cc: stable@kernel.org
> > ---
> >  drivers/acpi/sleep.c |   24 ++++++++++++++++++++++++
> >  1 files changed, 24 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > index f74834a..d907c8a 100644
> > --- a/drivers/acpi/sleep.c
> > +++ b/drivers/acpi/sleep.c
> > @@ -458,6 +458,30 @@ static struct dmi_system_id __initdata acpisleep_d=
mi_table[] =3D {
> >  		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
> >  		},
> >  	},
> > +	{
> > +	.callback =3D init_set_sci_en_on_resume,
> > +	.ident =3D "Dell Studio 1558",
> > +	.matches =3D {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1558"),
> > +		},
> > +	},
> > +	{
> > +	.callback =3D init_set_sci_en_on_resume,
> > +	.ident =3D "Dell Studio 1557",
> > +	.matches =3D {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557"),
> > +		},
> > +	},
> > +	{
> > +	.callback =3D init_set_sci_en_on_resume,
> > +	.ident =3D "Dell Studio 1555",
> > +	.matches =3D {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1555"),
> > +		},
> > +	},
> >  	{},
> >  };
> >  #endif /* CONFIG_SUSPEND */
> >=20
>=20


--=-T2c2KkFcCcmIPY158cUY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJMjmMWAAoJEOf3EFVUCeQiv38P/2vgtvLc3LpyZpTkcJQovN67
O247zgGiUyQdZV9FyYCojvMV2x2jQsN0qdpXfSTU9nibO7ep+FC+QbfCbEXWQx4J
iHVrZ+UtZGglpUKn6vkOJlluJ3g66zzSBaHLQCMZio0/+5g2tfQNsQA7JloVkL/q
rVVNzgKIt2xdDtFKmnXcg/D3i0dAtu43KddT5AxEQvzszeTRZ39jm67jMMsXRn3x
QUv2OElwYyUWB4xktEXL4JddCMYwOycT0xzy66EyYRAUAjm65BGnR6F4vmQm+tyl
8HUdPqvk82/rONouM/YJpGPd1vcMkIQU/7SuOM3MiZOOW/DdfSvBco9jNYQozmPV
1sB7DxXyB5e5MouSdg0fSxz6XgHXbfAHBwOBmTeJPf4xP9wnMo/lH+PpMOLPmDf+
iiBYY4m1nj15dq7i7Me1RKPcyYQB7uSlb8vInnHvPaVJQb1BxLhtGTJ7qjN7wuTr
V+qLt43ykal50PBlG3ujh9uEg6sAjwN8W/SyUf8FRm0Y6tAn2nVQ0eC3PImeWDf0
5vdcR8DwmIGwUlHsofSoBd3I+QAXB/fnNf+b56C2cQlz24AZACiUEYB3sWF1KT9u
qcAyV1dR3Z9rYISwKZQQG2uSYFYV1VW4GdlMNSM1o1jrw6e8q6VVlZN22Y5cJXM3
Rrf7S5pERi4K1HrqLJ7l
=VZYL
-----END PGP SIGNATURE-----

--=-T2c2KkFcCcmIPY158cUY--

