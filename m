Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2COCFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:05:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40730 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2COCFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:05:51 -0400
Date: Thu, 15 Mar 2012 13:05:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: linux-next: build failure after merge of the final tree
 (arm-soc tree related)
Message-Id: <20120315130541.d0d8c98d132a32dfe369ee19@canb.auug.org.au>
In-Reply-To: <CAP=VYLosYNbhGeUYyLr=0xa1UgK=fL-GOafySixFyQjy4GrdgA@mail.gmail.com>
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
	<CAP=VYLosYNbhGeUYyLr=0xa1UgK=fL-GOafySixFyQjy4GrdgA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_13_05_41_+1100_GRpqV_fK518ZNxD2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_13_05_41_+1100_GRpqV_fK518ZNxD2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, 14 Mar 2012 21:53:39 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> On Wed, Mar 14, 2012 at 7:59 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allmodconfig) failed like this:
> >
> > drivers/ata/sata_mv.c:4185:1: error: '__mod_of_device_table' aliased to=
 undefined symbol 'mvsdio_dt_ids'
> >
> > Caused by commit f1e1e148c5cb ("ARM: kirkwood: sata_mv: add device tree
> > binding").
>=20
> Looks like the same thing I reported in yesterday's triage that was
> screwing sparc:
>=20
> http://www.spinics.net/lists/sparclinux/msg09199.html
>=20
> Odd that it only started screwing powerpc today though.

It started affecting PowerPC with next-20120309, but I don't read the
build logs every day :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_13_05_41_+1100_GRpqV_fK518ZNxD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYU51AAoJEECxmPOUX5FEzucP/i1C1bmMEVQA1O7y2SskyxZJ
cam4R87x9pqVTdYbXMXmhnERIv0MitO93yn14ermGnosm2ZnzAt2xsz6zoAu7tz9
xKHF7s0KmK5aCJJ3mGEjuCo9hyy9hQdRpdSrC0O9+yKjZ5bbZgvffi8x5/9dKt06
K4GmqdxkbQLsNl2JZvNW46HGGMOwPKd+/bP0cNDiCjD1iWwjTkGIx6iqdxK0S8JA
dffnIs1iPuNjx0hB9GetZK8+bzeYMcyz0YnHmo/xifPkmnhTEEI+anq5zAyNPQtK
vGFhhFjxaVzV/XyNtbca4LMq8t9kyDeJYILED/JwFhO10xz4xICGoQzG0YU784Cp
nSBEskjd9KMiDzKqw8mZhbfc9iFxYVauCgjot9RO3/v+XW+f/7F20GZXMdpVrYq7
LMeioLrC9UCYdJsvrip5dK9NkzP5/jSBi54BeZQcQa1cYGIOu02aOaGY9DAYUUfA
yqUBKTvJifmO63JwvRxLO59w6/mmfIzILg+h+lvsMzyijBVB4xSoF93yaSc+5Vej
596NxJomjkaj9WhDCKCQjH6N35llg8PAe6X8a0Ycm00kLzQWxn7gENzOop4+KChT
exmhl74mxvlr5P+ok/ITIgHiAnNO0AI3V9pXXbEXnWPfLktMR45W72jIK0umvrXa
yQQXHkT1WdG4pN5JQ/Aw
=ulsn
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_13_05_41_+1100_GRpqV_fK518ZNxD2--
