Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2DKEfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 00:35:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45439 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2DKEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 00:35:23 -0400
Date: Wed, 11 Apr 2012 14:35:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <Sonic.Zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: Re: linux-next: triage for April 10, 2012
Message-Id: <20120411143509.338b075fa7e79dd9157f9ef7@canb.auug.org.au>
In-Reply-To: <CAMjpGUeKvP-fJG1sUPRtFDUWCwBg-19JFiFOAKJGmR8Pn4-XUA@mail.gmail.com>
References: <20120410224543.GA11433@windriver.com>
	<CAMjpGUetfGQxqTKVfLBtOdthxFtFv-knuXSWoNx0BKxJd=829Q@mail.gmail.com>
	<CAP=VYLrzvXCTD4J3sdhMCjnsPKvf-tobkE0G6OgTvc4mnEiw7A@mail.gmail.com>
	<CAMjpGUeKvP-fJG1sUPRtFDUWCwBg-19JFiFOAKJGmR8Pn4-XUA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Apr_2012_14_35_09_+1000_QDQ515D8dHeHa8Mk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Apr_2012_14_35_09_+1000_QDQ515D8dHeHa8Mk
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Tue, 10 Apr 2012 23:37:24 -0400 Mike Frysinger <vapier.adi@gmail.com> wr=
ote:
>
> On Tue, Apr 10, 2012 at 23:09, Paul Gortmaker wrote:
> > Thanks Mike, I'll fix the stale link. =C2=A0Here is a RELOC_BFIN_10 fai=
l:
> >
> > http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/
>=20
> hrm, i'm not seeing that here, but i'm using binutils-2.21.  we prob
> should file a bug for the Blackfin toolchain guys to investigate.
>=20
> what version of binutils are you using ?

$ /opt/cross/gcc-4.6-nolibc/bfin-uclinux/bin/bfin-uclinux-ld --version
GNU ld (GNU Binutils) 2.22

This is a cross toolchain hosted in PowerPC.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Apr_2012_14_35_09_+1000_QDQ515D8dHeHa8Mk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhQn+AAoJEECxmPOUX5FEL3cP/0Ht7T8VqkszZz0TlukfgbV7
uCvu4uCwe+3HrIzpN8nvmxLbpzCA10Ii/+a7Al/lMrxJM2DAZCqJvTo0GblAv2lm
vi4d+Qp/J5K8bvBDV8KTMlc2uLe3Hbz97/rqTIhGDl5jeuxYYjXz20GYFfiiYY94
3ufW5BSncu7ZIT+6/vaX0iWfVFsm0SRyWGJcDzzDapIFSX0HTV4Au+qH8zllv22M
3wd2bwk7T3RsUNYWiobBJ2QNLraGeNZAdx5X9CUFnd5KTUqoMMoSl0Mdw+xs8Ndq
+txiIr7Q/tM5lFS+/ho/QFzn581W7FwQfaMve7V1D1m7gcUFInyXA+B44NG7b2rw
/k2k4kLbX07MxC3XF6DhlmIG5b0xXmg/MdzZutUQmI4AoPfWEhBp9tyBvNhVj55W
NtngfdzfEnvMuKMwLhOcsp3MPMQMGoFsS1LwNWth9M9+d7v+Ht7PHTJqmeaaU79F
YFsUa2kXcF6wBybtV48HZKdDMEBHUO27f3lk1znDEGs10PbxA148Thtl8B0mZugm
DgaXpfPUTEgC5fdsbg2ZPykwq/vBg7WaLfd7ncbm4b/lzpHQxn1FL3y7nLSkmtnW
8JmaoP1vub0KN1abZi2K5QgMtDovvtyWfvz2SNOtvuQHDjMxzRaodY41/WBKfKUN
BeOmbXUhOE9UBh15zRyS
=LjYU
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Apr_2012_14_35_09_+1000_QDQ515D8dHeHa8Mk--
