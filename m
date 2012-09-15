Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2IOCTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:19:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089Ab2IOCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:19:34 -0400
Message-ID: <1347675555.13258.95.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 44/85] ACPI: export symbol acpi_get_table_with_size
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Date: Sat, 15 Sep 2012 03:19:15 +0100
In-Reply-To: <20120912233546.374732884@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
	 <20120912233546.374732884@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-v+xhpwCKImuUHCCwCc8B"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v+xhpwCKImuUHCCwCc8B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 16:36 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alex Deucher <alexander.deucher@amd.com>
>=20
> commit 4f81f986761a7663db7d24d24cd6ae68008f1fc2 upstream.
>=20
> We need it in the radeon drm module to fetch
> and verify the vbios image on UEFI systems.

Same as for 3.0, this seems pointless without the dependent radeon
changes:

268ba0a drm/radeon: implement ACPI VFCT vbios fetch (v3)
7c3906d drm/radeon: convert radeon vfct code to use acpi_get_table_with_siz=
e
c61e277 drm/radeon: split ATRM support out from the ATPX handler (v3)

(For 3.2 I also needed these fixes from 3.3:

a3f83ab drm/radeon: fix invalid memory access in radeon_atrm_get_bios()
211fa4f drm/radeon: finish getting bios earlier
de47a9c drm/radeon: fix use after free in ATRM bios reading code.

but I don't know whether those would be sufficient to backport this lot
to 3.0.)

Ben.

> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/acpi/acpica/tbxface.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/drivers/acpi/acpica/tbxface.c
> +++ b/drivers/acpi/acpica/tbxface.c
> @@ -436,6 +436,7 @@ acpi_get_table_with_size(char *signature
> =20
>  	return (AE_NOT_FOUND);
>  }
> +ACPI_EXPORT_SYMBOL(acpi_get_table_with_size)
> =20
>  acpi_status
>  acpi_get_table(char *signature,
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-v+xhpwCKImuUHCCwCc8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFPlo+e/yOyVhhEJAQr1EQ/8CXrY5kdh/GjV3Rc8Hc9eJSi6l7d8tO+v
21g1XUiwD2mI3kwZrPZIwVeZ7H3bTPXVFv4uGJxx1qI4mBAapCLOjug3oWwUeK1M
r5eS/6WAhzpkhbqpRBtD50nZxQVdrlECPj+ONTSsIjdcvAONjcy/ZqYoXWAV6oxJ
hvjF8Z/DiLpDKMhpdTYbhMoFTj8NfuRQmPsv8bCC4PnRm2q1Uuj6ONTCFM1oX3ZP
6abbednjbTkFkulecAkRmXlP3ZAL6RucIWmAq3EWoLI5MCNco9QOEMhJpljfiXV4
t/j+Qu4s9icYj4pqlPDeQ/YUfU+KgkUbZifY+ws9pok3wOH3ZLAMTgTlShcm8dp6
r1GsEDGsxr5MoBQXcIvMnsNSSqrvJ1QM1Opfzbt2VMz1Gb9u9ywV1KYZNw61VS8R
qec8VpENaasSEJnkDBYHMzv41mO+jJfNOb5mzqKVTHizcXYWQtd9Lnn5LC1hEtSD
1/yRyJb4PtwJf7AfLtkxfmMREz3Up84sgkAyucGC0R7detPf2AVpvOpPh7pHD88/
GgS4f9+op0MsNPm5F/FXwR6KkPlD2fTLkByhzynwYE+GqMWV+ABBNt/GgAuk4lhp
/JHWvfjFTrnYNcRlUVbVmpfedVSJmqz85zGP0RPoA8I/TYBz4EAYIB28WYuFYKTc
F7HY9Irp7AQ=
=rO0h
-----END PGP SIGNATURE-----

--=-v+xhpwCKImuUHCCwCc8B--
