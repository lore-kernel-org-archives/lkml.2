Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0FIUCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:02:25 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:35386 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0FIUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:02:24 -0400
Date: Wed, 9 Jun 2010 17:02:18 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Daniel Oliveira Nascimento <don@syst.com.br>
Subject: Re: [PATCH -next] classmate-laptop: fix for RFKILL=m, CMPC=y
Message-ID: <20100609200218.GD2551@barata.holoscopio.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
 <20100603093903.d9378c9a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <20100603093903.d9378c9a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2010 at 09:39:03AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix build error when CONFIG_RFKILL=3Dm and CONFIG_ACPI_CMPC=3Dy:
> classmate-laptop should depend on RFKILL or RFKILL=3Dn.
>=20
> classmate-laptop.c:(.text+0x1351fc): undefined reference to `rfkill_unreg=
ister'
> classmate-laptop.c:(.text+0x135204): undefined reference to `rfkill_destr=
oy'
> classmate-laptop.c:(.text+0x135237): undefined reference to `rfkill_set_s=
w_state'
> classmate-laptop.c:(.text+0x1352b9): undefined reference to `rfkill_alloc'
> classmate-laptop.c:(.text+0x1352ca): undefined reference to `rfkill_regis=
ter'
> classmate-laptop.c:(.text+0x1352d6): undefined reference to `rfkill_destr=
oy'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---


Randy,

Since this implies a build failure, shouldn't it be sent for rc too?

Best Regards,
Cascardo.

>  drivers/platform/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- linux-next-20100603.orig/drivers/platform/x86/Kconfig
> +++ linux-next-20100603/drivers/platform/x86/Kconfig
> @@ -520,6 +520,7 @@ config TOSHIBA_BT_RFKILL
>  config ACPI_CMPC
>  	tristate "CMPC Laptop Extras"
>  	depends on X86 && ACPI
> +	depends on RFKILL || RFKILL=3Dn
>  	select INPUT
>  	select BACKLIGHT_CLASS_DEVICE
>  	default n

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMD/NJAAoJEEWxSg7udFZIEjIQAIenV6K05GdBWoI1YqO038Wf
mSUDfHv5jpeHUk2FR/nHo5Ky48uO+kHHQJ1zdZXUy4XZSnTlCXfiWCAc4rHdL2KC
V83a9xtQNTxCnqFuLWaOG3VYvbIyt/XHmfVRQg1aZyjhRqs3LjXYLi+LZ9ryDnZQ
63n6RpysYu3gi1yurA9SBmVj7MjEU2mZryEbUVGyKbKbm0fSx8Kd50rRJHVXcqFk
8JH9uImiW8kvNUq2Zpn0oarBRVSO+oCzVNnLGaSKT41n2dWQCHP1iFftxkwU2tO1
KkLu3+7fPTyJNAKboEMJRg8UVgjThdTBwYpON5invH4mkNypuz7ux5F9wnqEEjTl
Q/rFLgG5jASv/q+5/u03sdpdibXxe9vT0mGXUojmMWx+7tlrUyeyU5sljT9nV8qf
5MDLJQFuxwOOeIzgSVlUlAy9YmB7XQWJnai2Y6Z4+nvBCTeLdqDAyX7B4wGVvmEA
yQOxz6fJsYmQUWSWc8VlbIP/P3U3etx4uQ6Q3itWMvDuWmhsjd9f4F8jjO/r+qAz
JKvKoMzdOwAhYQV2TRnAoeNBqKYn8bSroJtISrxSNMtewwd/VeilIcg749ZMS4NI
sGFCig8LyzBcRUUFj7tER2BLlCXd9flDTjTewWY/w4S3s0mqC209efVUL85BEz2M
G630J4qyYNdP0qUhfgvW
=vXM3
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
