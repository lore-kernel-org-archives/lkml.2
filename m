Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2IOAWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 20:22:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab2IOAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 20:22:30 -0400
Message-ID: <1347668540.13258.87.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 24/46] ACPI: export symbol acpi_get_table_with_size
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Date: Sat, 15 Sep 2012 01:22:20 +0100
In-Reply-To: <20120912233820.189480865@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
	 <20120912233820.189480865@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0uUmAv0QUCubYwP88suX"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0uUmAv0QUCubYwP88suX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 16:39 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
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

Unless you're planning going to include those radeon changes in the next
update, I don't see the point of this.

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
> @@ -435,6 +435,7 @@ acpi_get_table_with_size(char *signature
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

--=-0uUmAv0QUCubYwP88suX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFPKPOe/yOyVhhEJAQrDNBAAxSJ9UOkiGZIrCqVplVYD/E4X9wE6CDkc
zXlOc2QTpb3HVVR+7JoEwtbHCfO+/FJCDHijEqYibQHJjEJX17Jy5vuBChzfe5YM
r2W8mX/esyZhkfaQ9kHAvGn/fYv1sMhZV5WFHZL3ysIsYQPgOgR+rjLRYrE+HLa9
p8qNVtfrJ+C42hOaKwNasXiTE5xQ8RPH+a+2PjeIbvRbgVivTmKm45hOy/cX2MZ5
ACw6rYR7lul+9XM7hBevTE2wL43VuQGE35WEnzM3Z8BO9l341r9ANTummtFDI6v4
dKe399fix4u1jqHHOe6gkXN9zBUTTyLIw9fUiV4ApAQFfJqnfGtUUTqa0YBJARR9
Ff22nuXXreYwRRcKFuCGXSdu8hW06g6/EVopYPzdW5NeSO/exeZggxhOGf4Axqbi
3bLLLITeOjju7spIx25MCtZyqxm1zPxwv9RSmb3PyxsIsznhK9/w/T1AK5WktfHm
Ah+TMTuUbgtHm1S0+3Vl1QHPx8gB/wIv6mZ8+uSymbHNXr1QoHF2O2hOYxrH48PI
v+hOIs8QLg1Mf8PWYL8+VmMBOyfp29dL7JVfCeJMNFQ9dFCMyQP+/JNyyX4YRKMz
JsX/zGo76ZRLonLl0IDfDmZXGklngeU4s2HiJcRwsyCzmxCBtxdDC3k/vf/GPr1l
yEsbJld6+as=
=Wt1I
-----END PGP SIGNATURE-----

--=-0uUmAv0QUCubYwP88suX--
