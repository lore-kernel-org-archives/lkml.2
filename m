Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935655Ab2JYNdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:33:09 -0400
Received: from mail.southpole.se ([193.12.106.18]:51280 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab2JYNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:33:06 -0400
Message-ID: <1351171980.6232.64.camel@jerome.southpole.se>
Subject: Re: [PATCH] openrisc: use kbuild.h instead of defining macros in
 asm-offset.c
From: Jonas Bonn <jonas@southpole.se>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 15:33:00 +0200
In-Reply-To: <1349946181-27277-1-git-send-email-james.hogan@imgtec.com>
References: <1349946181-27277-1-git-send-email-james.hogan@imgtec.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-10yI3hlg0BIMNGeGpbIL"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 71983-01517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-10yI3hlg0BIMNGeGpbIL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-11 at 10:03 +0100, James Hogan wrote:
> This is modelled on commits such as the one below:
>=20
> Commit fc1c3a003edb8a6778e64e10ef671a38c76c969e ("sh: use kbuild.h
> instead of defining macros in asm-offsets.c") introduced in v2.6.26.
>=20
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Thanks, looks good.  Will take this for 3.8.
/Jonas

> ---
> Note I haven't tested compilation on openrisc. I'd appreciate if
> somebody could check it doesn't break anything.
>=20
>  arch/openrisc/kernel/asm-offsets.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/openrisc/kernel/asm-offsets.c b/arch/openrisc/kernel/as=
m-offsets.c
> index 1a242a0..ddb7368 100644
> --- a/arch/openrisc/kernel/asm-offsets.c
> +++ b/arch/openrisc/kernel/asm-offsets.c
> @@ -34,15 +34,11 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  #include <linux/thread_info.h>
> +#include <linux/kbuild.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>  #include <asm/processor.h>
> =20
> -#define DEFINE(sym, val) \
> -		asm volatile("\n->" #sym " %0 " #val : : "i" (val))
> -
> -#define BLANK() asm volatile("\n->" : : )
> -
>  int main(void)
>  {
>  	/* offsets into the task_struct */


--=-10yI3hlg0BIMNGeGpbIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCJP40ACgkQ70gcjN2673MKhQCgq6K1tYa35YrSfKZ4YJ4j9Mip
kPYAoLaocZoxDj7m7ReAvXYkat039q8W
=6B0x
-----END PGP SIGNATURE-----

--=-10yI3hlg0BIMNGeGpbIL--

