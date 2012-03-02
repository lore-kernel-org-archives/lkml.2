Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab2CBHM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:12:57 -0500
Received: from mail.southpole.se ([193.12.106.18]:41284 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CBHM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:12:56 -0500
Message-ID: <1330672347.19557.107.camel@satguru>
Subject: Re: [PATCH 5/5] OpenRISC: Export dump_stack()
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 08:12:27 +0100
In-Reply-To: <1330649715-32438-5-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
	 <1330649715-32438-5-git-send-email-richard@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8RW2RStjHwSwE7SBaDUC"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 72374-08440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-8RW2RStjHwSwE7SBaDUC
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks.  Patches 1 and 5 from your series applied.

I already had patch 4, and comments have been sent for the others.

/Jonas

On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
> dump_stack() is used by modules and needs to be exported.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/kernel/traps.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
> index a4ec44a..ab68ffc 100644
> --- a/arch/openrisc/kernel/traps.c
> +++ b/arch/openrisc/kernel/traps.c
> @@ -115,6 +115,7 @@ void dump_stack(void)
> =20
>  	show_stack(current, &stack);
>  }
> +EXPORT_SYMBOL(dump_stack);
> =20
>  void show_registers(struct pt_regs *regs)
>  {


--=-8RW2RStjHwSwE7SBaDUC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9QctsACgkQ70gcjN2673OQVACgkpAl+QHUfiRmvn6O6FNnb/pr
vzYAn36N1FfB3ALjShGD8OgKsx/JKnlT
=FGRD
-----END PGP SIGNATURE-----

--=-8RW2RStjHwSwE7SBaDUC--

