Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1J1SqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:46:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46403 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab1J1SqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:46:03 -0400
Date: Sat, 29 Oct 2011 05:45:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>
Subject: Re: HSI framework for linux-next
Message-Id: <20111029054547.d38e09b870ad5b8b2dd2008a@canb.auug.org.au>
In-Reply-To: <1319794066.28874.22.camel@groo>
References: <1319794066.28874.22.camel@groo>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__29_Oct_2011_05_45_47_+1100_EvX5N.aYlL/.=rwS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__29_Oct_2011_05_45_47_+1100_EvX5N.aYlL/.=rwS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Carlos,

On Fri, 28 Oct 2011 12:27:46 +0300 Carlos Chinea <carlos.chinea@nokia.com> =
wrote:
>
> I have been working in an HSI framework for linux:
>=20
> https://lkml.org/lkml/2011/6/10/280
>=20
> The framework is in good shape and is currently being used for some
> people so we would like it to see it integrated, if possible, for 3.3
>=20
> Latest discussion for integration:
> https://lkml.org/lkml/2011/10/20/177
>=20
> Therefore, could you add the following tree to linux-next ?=20

I will try to remember, but if I forget, then ping me when v3.2-rc1 has
been released.  I don't put future code into linux-next until after -rc1
to save false problems with the stuff that has still not been sent to
Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__29_Oct_2011_05_45_47_+1100_EvX5N.aYlL/.=rwS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOqvhbAAoJEECxmPOUX5FE4hoP/1X8lSwA6g1wMEjG4CnBnMKj
Tsy052nOpmo1KmFuQvG1uAGLHOIdGY3WymrhG40mC/jkPE+1Bci7KDvXeq04WsCS
QCPVQxKc9n+EzzGLNDkeTH+MZLYKpzaCdMz7HKyNsRbrcVTYA7nz71LfBc6uIrsk
KtZlDd4OT0qQcW4eT8NtYoc/DGWIexmTQsW2KQc1L9brzwZdEJFHDpzMbHEAR13O
RLihPOwudn9JwUC8gWjReG2LwKrWZnh07n6gXBf5jtvVrbmtt9KrjLr4v0L+Rzht
ikSR3EexIUQtur4y5NsohlY792ZPHhVb0oxCIydMRsiDvgLTqIw4eOwqDCKh+lad
UBgVyp8ugs5ygcY/lQLUjrVvLtPi65ENfAMpIgRhpgtCLfAdov42hrH/5xXQkmma
0dm4HwK3WKelSPc1nKpWe6JfrvooXXMXMnlHeCW14pO45Ns4VgMEcJyQuHaV6B7t
EDQ4X7rOvCnkEjE4//3o1EKVD+rVuKcidMVJ7Scdrpk4e7yf+DAeQQvOCLs+a1NI
o/XUdKaic+OlNYqnM71m4EYoHy2BWWsCQC8ydzWTiI/7eaI4FehIN5XfXSPLGN00
4bTMejWBn3nPy2Il7GFa5LTUsjUePiGXGkYNtZ5LGhImo5zukmaim4BTrbGrgv47
XsiLrNqokzPotk9qsHAW
=qhtN
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Oct_2011_05_45_47_+1100_EvX5N.aYlL/.=rwS--
