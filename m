Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2CBGu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:50:56 -0500
Received: from mail.southpole.se ([193.12.106.18]:43883 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2CBGuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:50:55 -0500
Message-ID: <1330671026.19557.99.camel@satguru>
Subject: Re: [PATCH 2/5] OpenRISC: Use generic bitops.h
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 07:50:26 +0100
In-Reply-To: <1330649715-32438-2-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
	 <1330649715-32438-2-git-send-email-richard@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3F3suA5mgsQ4AbBYT+CJ"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 71053-04576
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-3F3suA5mgsQ4AbBYT+CJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
> There is no need to reinvent the wheel.

NAK... we have optimized versions for some of these operations so the
generic header isn't right for us.

Have a look at arch/openrisc/asm/include/bitops.h to see which functions
we override with accelerated versions.

/Jonas

>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/include/asm/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm=
/Kbuild
> index 11162e6..a283165 100644
> --- a/arch/openrisc/include/asm/Kbuild
> +++ b/arch/openrisc/include/asm/Kbuild
> @@ -4,6 +4,7 @@ header-y +=3D spr_defs.h
> =20
>  generic-y +=3D atomic.h
>  generic-y +=3D auxvec.h
> +generic-y +=3D bitops.h
>  generic-y +=3D bitsperlong.h
>  generic-y +=3D bug.h
>  generic-y +=3D bugs.h


--=-3F3suA5mgsQ4AbBYT+CJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9QbbIACgkQ70gcjN2673OdfwCfUl6KKhy+XpQOUkdmbXeHCceQ
24oAnjf1b8+TFHZIV3fMKrX6BYCGv7vi
=cxUK
-----END PGP SIGNATURE-----

--=-3F3suA5mgsQ4AbBYT+CJ--

