Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab1DAQGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:06:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35916 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab1DAQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:06:38 -0400
Date: Sat, 2 Apr 2011 03:06:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when
 CONFIG_DEBUG_SECTION_MISMATCH=y]
Message-Id: <20110402030628.36a0b822.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=td3J2duwv9RuXJHquA6=wRRq8vWLkJY97xtP9@mail.gmail.com>
References: <AANLkTi=td3J2duwv9RuXJHquA6=wRRq8vWLkJY97xtP9@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_Apr_2011_03_06_28_+1100_D4GUIo8BDlyBX/5C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Apr_2011_03_06_28_+1100_D4GUIo8BDlyBX/5C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Artem,

On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>=20
> With CONFIG_DEBUG_SECTION_MISMATCH=3Dy set, I see in my build.log:
> ...
> MODPOST 2742 modules
> ...
> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
> make[5]: *** [__modpost] Error 1
> make[4]: *** [modules] Error 2
> make[3]: *** [sub-make] Error 2
> make[2]: *** [all] Error 2
> make[2]: Leaving directory
> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686=
-iniza'
>=20
> - Sedat -
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_Apr_2011_03_06_28_+1100_D4GUIo8BDlyBX/5C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNlfgEAAoJEDMEi1NhKgbsEQ4H/2S1/0OEiLTVGEsVm4DYB8WV
SqfjX0qggS8sCLnyn9MWx+Q2gDLnhavQAJ+4XeGhQ7uGhyibBl8uvDoJ/D1Q1pza
Uf4Xmf/mImLrzC1XyqDMw6/jYM9v8loGFtmAtXgxRpmP0NQr5Ea7B4mixSKiSZ51
NQtu31ZdXfbNqV2yuHV0XTK36D3+pZmi+2BkGmxbrg/Tt7Uv3Eev/769WB082Lx+
2xMxVVZN1PqEEm5Go6QMqCsLNbY0o8Zp8eFC7jeg95iQK88EzRk6lFhLDYyvcNtR
SvIvImipkpembVzoYqRB5Cj50GUlNU3weZgZKDGSkxt2a3+Z6Z+gUrpgTT6NE9M=
=zSGN
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Apr_2011_03_06_28_+1100_D4GUIo8BDlyBX/5C--
