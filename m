Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0JQJRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:17:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33784 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0JQJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:17:11 -0400
Date: Sun, 17 Oct 2010 20:17:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
Message-Id: <20101017201705.75e381d0.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTinLBfAqRtd22MJtN+-LYsfvPSnRWcS97iM2PGJy@mail.gmail.com>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101016151442.a21769f6.rdunlap@xenotime.net>
	<AANLkTinLBfAqRtd22MJtN+-LYsfvPSnRWcS97iM2PGJy@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Oct_2010_20_17_05_+1100_.TeCaVDyNDWL_J5y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Oct_2010_20_17_05_+1100_.TeCaVDyNDWL_J5y
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sun, 17 Oct 2010 10:02:25 +0200 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> On Sun, Oct 17, 2010 at 00:14, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > BTW, do you use LC_ALL=3DC when doing builds? =C2=A0I'd like to be able=
 to read
> > messages like this one:
> >
> > src/Documentation/spi/spidev_test.c:56: warning: (near initialization f=
or =C3=A2=E2=82=AC=CB=9Ctr=C3=A2=E2=82=AC=E2=84=A2): 1 warnings in 1 logs
>=20
> I just grab the logs from the linux-next build service.

I will talk to Michael about that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__17_Oct_2010_20_17_05_+1100_.TeCaVDyNDWL_J5y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMur8RAAoJEDMEi1NhKgbso6UH/0rMORagm7jLpv4lrohV7uju
Q6BoVwGFPbVYF7C6Ah1rk+eS31bXU7heNe7kaGhyzjp33p4/8evR4xigkqe2UZNV
6BYsN4abnk5eJ6sqV0KkfT/AR4VO7HHes3fh2rfNvbm29BFD4dbk2vOy+JB9q9ch
QUnqN4Er6v0eBt0AKftqE0/1iEq2Ouds95EQg0AHV7vcXf+7DcJQgRQ/nEkWf32Q
IW6Fxq3T6Xa/42fWTMOJklLOe4Y7AL9RL9cqULez0Hok8p8qRDuDTKQKr9wJhTby
alHMmgo78p5fBBruaHcajEoEuFwSTMHetyCQx3N46uVJHolUjnZ9qUYmr4F0QMM=
=/F8/
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Oct_2010_20_17_05_+1100_.TeCaVDyNDWL_J5y--
