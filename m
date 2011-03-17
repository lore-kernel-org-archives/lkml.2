Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1CQFp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:45:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44208 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1CQFpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:45:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Thu, 17 Mar 2011 01:45:45 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103162257.10440.vapier@gentoo.org> <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
In-Reply-To: <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1704446.IzFq2RYmyt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103170145.46326.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1704446.IzFq2RYmyt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> > ok, took long enough, but that answers most things.  your usage of "x32=
=2D"
> > prefixed binaries in the documentation seems to imply a lot more than t=
he
> > fact you just picked those locally to avoid system collisions.  this
> > isnt a wiki page, otherwise i'd clean things up for you.
>=20
> Any suggestion how to create a wiki page for x32?

seems like the sites.google.com documentation says it includes wiki support.
	http://sites.google.com/site/projectwikitemplate_en/

ive never used google sites before, so i dont know how to actually enable i=
t=20
on the admin side of things.

> > in looking at the gcc files, it doesnt seem like there's any defines
> > setup to declare x32 directly.  instead, you'd have to do something
> > like: #ifdef __x86_64__
> > # if __SIZEOF_LONG__ =3D=3D 8
> > /* x86_64 */
> > # else
> > /* x32 */
> > # endif
> > #endif
> >=20
> > any plans on adding an __x32__ (or whatever) cpp symbol to keep people
> > from coming up with their own special/broken crap ?  or are there some
> > already that i'm not seeing ?
>=20
> The idea is in most cases, you only need to check __x86_64__ since x32 and
> x86-64 are very close.  In some cases, x32 is very different from x86_64,
> like assembly codes on long and pointer, you can check __x86_64__ and
> __LP64__. In glibc, I used a different approach by using macros REG_RAX,
> .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly codes.

arm/mips/ppc sets up explicit ABI defines to clearly differentiate between=
=20
things.  while __LP64__ should work here, it seems like a poor substitute. =
=20
how about builtin_define("__X32__") ?  or __ABI_X32__ ?  doesnt seem like i=
386=20
has a standard in this regard to piggy off of.
=2Dmike

--nextPart1704446.IzFq2RYmyt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNgaAKAAoJEEFjO5/oN/WBeaUQAJDL6HRSRh3OT884mVHGzzG/
ndVupj9BUnqtPCrwN4XKS/S1wiF1oKQAoulP8MCHTo8FhojjU5/kFiFLnsuuNd2s
8a00IBKavJgSAJv2bYzjJKaZ/sFH5mM77d8SoLZPtQuXnREtTjwhZ3jgKd0SbsIX
ltTyGFWkslZefh+5N5T64w0m9UuotHOQViUECmbr9j+3lsAvoISoDv5B6xHoLftX
dwFfvQPMV+6rFMZgcLt5214hGHAZ4oN+KUv8Nk+O6/dRENhxt1uTg6mT7uEeTEGu
aEM6m56peuzHNM0NJmPkMdDaXamlfCNca75UtHFro8UEBHyXGdErdr2FBHA1QZK9
XSyib7SW4Y5fgU6PcdjSimDmzLErR5EclP66XjVvquVml7+qPAnAMfcrlpJWgvc+
tS9UoVpqOqIAn0ashxx83hZXoM4WAy0L7NjSYWAL/7bJS4Zhl9vRoCdGDoT59JAc
mL8u0yfzoKZtGh3RO7LlV00VGgoPpoO7MAur4xeTrrFMh9e9KOcZrP5gr7EGT4Fp
0w4fJd+5p1WUQpIvvDDs7piXlqXJd/VW5cm8b+tTFloNXDjk2vlogRUoqXHuHdfB
HyZOiZrU6j4SxKqAG2Ds6R3eFmLtEhP1z+VYBaOxzwG2M/hyJn9k0JAaFyiCBV1A
gkU0BdVc++t+Nft7p64X
=g7zi
-----END PGP SIGNATURE-----

--nextPart1704446.IzFq2RYmyt--
