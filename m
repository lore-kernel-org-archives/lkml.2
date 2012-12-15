Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2LOWKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:10:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38032 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2LOWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:10:12 -0500
Date: Sun, 16 Dec 2012 09:10:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH 3.7.0 1/9] i82975x_edac.c: fix style errors
Message-Id: <20121216091003.e9d2e3503e246ac714ef3419@canb.auug.org.au>
In-Reply-To: <CAA_L+UP_CtY4wTnOGASwqb9PJnb9XyGpGauTKk6=wssagg1GPw@mail.gmail.com>
References: <CAA_L+UP_CtY4wTnOGASwqb9PJnb9XyGpGauTKk6=wssagg1GPw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__16_Dec_2012_09_10_03_+1100_prJs6CU.IplVPVzz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__16_Dec_2012_09_10_03_+1100_prJs6CU.IplVPVzz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arvind,

On Sun, 16 Dec 2012 02:08:50 +0530 Arvind R <arvino55@gmail.com> wrote:
>
> Subject: [PATCH 3.7.0 1/9] i82975x_edac.c: fix style errors
>=20
> splits or shortens extra long lines in source.

Don't do this, except for the one marked below, these add no value.  The
line length is a guide.

> -			snprintf(csrow->channels[chan]->dimm->label, EDAC_MC_LABEL_LEN, "DIMM=
 %c%d",
> +			snprintf(csrow->channels[chan]->dimm->label,
> +				 EDAC_MC_LABEL_LEN, "DIMM %c%d",

Only keep this one.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__16_Dec_2012_09_10_03_+1100_prJs6CU.IplVPVzz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzPU7AAoJEECxmPOUX5FEkp8P/2yQLxvJF9rbZz2seIc4FPi1
JYtIzkn/2cZDvIZmUi0yqnv6BME5p0sjElZkt4J2OlgVMaJseDL6V4N7+8lWi0dn
MdG/78ILPdTw/FAY9vAL3ryXzmT5PuSS3qfWmE5RqrMZmm8ge+n6ED99yDv7y2H7
wOPdqtkNE3bWrFV+sa3CucnTspW6HZ3U2V5PRb+6/KRQVwoqru3soNmDw6jk2aCJ
4lVoviImj8ERBIh/irFsyZ3VGUtodtKAQV8rZyhEA6zJB0OSgirOfXhxrGR1vSk7
1M1mcDU6UA7ru16c0v8bfcU+693Xgmv6l4oMggRLVUpEfyMxgVkMCf/TaXTm6gdI
8Gs3ZBPiqRKIabMTVgH0zY33meNaCcAoJ2NHUTFIkm93TPTyWjABybEW4+aNVodp
2Xj/AMXotoR77mzsn3dffVUF3PPHVPd8Hs7k7Eg9lpoL8Dkl6oxnBh2ZfFwMGO66
iNB2ZW8UG5DzVVJnSeSdEbtUHHuusHolFkQmSLPmo95Nh21N6JvCa/zsBaCuwjkI
Cf+Zu/n5MoYvfir1gk7bFLUUJVr9SvieB6E/gF0tKNqA5GLpektUyfTrv/ySnEpq
0MC84MTy6oyDFRO35s2LPlwzJBaMWRVO1elqrWuv9FfGrQMA6LF1bZlXKG6VJpW1
r6FlI6tMXsLitGuc3lK+
=zYGM
-----END PGP SIGNATURE-----

--Signature=_Sun__16_Dec_2012_09_10_03_+1100_prJs6CU.IplVPVzz--
