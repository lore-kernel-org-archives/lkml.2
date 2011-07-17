Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1GQXQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:16:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56870 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab1GQXQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:16:37 -0400
Date: Mon, 18 Jul 2011 09:16:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: rdunlap@xenotime.net, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix compilation warning when CONFIG_PNP is not
 defined
Message-Id: <20110718091624.bd262188190c5d7a05416b99@canb.auug.org.au>
In-Reply-To: <1310903758.15064.9.camel@d941e-10>
References: <1310903758.15064.9.camel@d941e-10>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_09_16_24_+1000_Sfwjr4.RsX0XiBnz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_09_16_24_+1000_Sfwjr4.RsX0XiBnz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Sun, 17 Jul 2011 07:55:58 -0400 Stefan Berger <stefanb@linux.vnet.ibm.co=
m> wrote:
>
> The is_itpm() function is only accessed from a block surrounded by
> #ifdef CONFIG_PNP. Therefore, also surround it with #ifdef CONFIG_PNP
                ^^^

> --- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
> +++ linux-2.6/drivers/char/tpm/tpm_tis.c
> @@ -80,7 +80,7 @@ enum tis_defaults {
>  static LIST_HEAD(tis_chips);
>  static DEFINE_SPINLOCK(tis_lock);
> =20
> -#ifdef CONFIG_ACPI
> +#ifdef CONFIG_PNPN
                 ^^^^
Is this a typo?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_09_16_24_+1000_Sfwjr4.RsX0XiBnz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI21IAAoJEDMEi1NhKgbsC7AIAJCXuCvY0V1QVMs8TUdCJo+P
zTJXc3Te1F6Dai+0WLF5MTBL0SDMiRh+AYYJxpWIh45Kryi4y2R9roG8JnOyIDQv
P5U69P+PmepW2ppI1MqyTsA2klu1fKtrsQ1FA9GntG0yw4bEgF/rMUOXT+kvNBt5
zm+lfVCsMjl33DmuBKedyUb6dtilp7Xe3zODryV45UeQTRMJbxTrXMx6Tl78Q5gj
HM6NnrjTOrtVgpdoiEcOPR/n6cVcI+MNoumcIVevOrCInMPwfUaaQexRraDAzMVp
2Tm/m/aw+bnyOgd0k2G7RGM/oZIftJKz94h1zwwRp2QajTRFG+TBphOuO9+q+4A=
=rX8J
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_09_16_24_+1000_Sfwjr4.RsX0XiBnz--
