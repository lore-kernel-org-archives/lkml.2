Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0JRF15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:27:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40028 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0JRF14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:27:56 -0400
Date: Mon, 18 Oct 2010 16:27:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au
Subject: Re: Build regressions/improvements in v2.6.36-rc8
Message-Id: <20101018162744.412d8989.sfr@canb.auug.org.au>
In-Reply-To: <20101017201705.75e381d0.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101016151442.a21769f6.rdunlap@xenotime.net>
	<AANLkTinLBfAqRtd22MJtN+-LYsfvPSnRWcS97iM2PGJy@mail.gmail.com>
	<20101017201705.75e381d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_16_27_44_+1100_q4PLkOPS0QrEwCZz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_16_27_44_+1100_q4PLkOPS0QrEwCZz
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sun, 17 Oct 2010 20:17:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Sun, 17 Oct 2010 10:02:25 +0200 Geert Uytterhoeven <geert@linux-m68k.o=
rg> wrote:
> >
> > On Sun, Oct 17, 2010 at 00:14, Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
> > > BTW, do you use LC_ALL=3DC when doing builds? =C2=A0I'd like to be ab=
le to read
> > > messages like this one:
> > >
> > > src/Documentation/spi/spidev_test.c:56: warning: (near initialization=
 for =C3=A2=E2=82=AC=CB=9Ctr=C3=A2=E2=82=AC=E2=84=A2): 1 warnings in 1 logs
> >=20
> > I just grab the logs from the linux-next build service.
>=20
> I will talk to Michael about that.

Turns out that we do build with LANG=3DC, but the Geert is grabbing the
logs embedded within the full results web page (which converts the '
characters to &#39).

Geert, to fetch the full log as a text file, just append "log/" to the
results page url.  For further help with what you are trying to do,
please email Michael Ellerman (cc'd).  He can possibly add useful other
urls or interfaces for you.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_16_27_44_+1100_q4PLkOPS0QrEwCZz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu9rQAAoJEDMEi1NhKgbse9sH/2z41/6ENdEM9/MxmO4WbDAM
NGEAxqqs//pBiLzthnkA56a4YlsYyqaIQj6xsmm5OfuuPmdemPmuM/+wIRKo0osy
wQal6DDzg+ASlVzVv8yrsA9O4xHkz5D/zIUpo+vSxkOg+NMF3vsyuvQkf0rKb+Ye
OGLpnu/afThBXrJsZjVbVr7JO2GX0pI+DohfrKjyKe4VcF8dyyhVJM6yWLLf6H5A
zUGQuawsvzbp4cJPGGo75EydJRKEKo3elO81C51Zz8w1j7hCFaRbSB97NijJXm6F
b3j1QbIR/7AdMTKyy7xMB0E1qf662g7M82F1eNw6RU8V25iIn9QfWDq+3ka6xiw=
=3Df/
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_16_27_44_+1100_q4PLkOPS0QrEwCZz--
