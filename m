Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1CPFYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:24:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1CPFYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:24:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Wed, 16 Mar 2011 01:24:41 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103160030.27594.vapier@gentoo.org> <AANLkTimk3dfOBoPhGQ8NeOYY5rKdsefPm8gTJ-75vg3-@mail.gmail.com>
In-Reply-To: <AANLkTimk3dfOBoPhGQ8NeOYY5rKdsefPm8gTJ-75vg3-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1480052.zWKNAQ7hHJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103160124.42939.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1480052.zWKNAQ7hHJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 16, 2011 00:51:37 H.J. Lu wrote:
> On Tue, Mar 15, 2011 at 9:30 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> > On Wednesday, March 16, 2011 00:17:04 H.J. Lu wrote:
> >> On Mon, Mar 7, 2011 at 1:33 PM, Mike Frysinger wrote:
> >> > On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
> >> >> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
> >> >>=20
> >> >> https://sites.google.com/site/x32abi/
> >> >>=20
> >> >> The major remaining issues are glibc/gcc testsuite failures,
> >> >> kernel core dump and signal handler unwind.
> >> >=20
> >> > are you getting a unique host tuple for this ?  or are you extending
> >> > x86_64- linux-gnu ?  so the only way of knowing which ABI is to check
> >> > for the output of the compiler+compiler flags ?
> >>=20
> >> x32 requires x32 enabled x86-64 kernel.
> >=20
> > ok, but that doesnt answer my question.  what are you passing to --targ=
et
> > ?
>=20
> See:
>=20
> https://sites.google.com/site/x32abi/
>=20
> You configure it as
>=20
> CC=3D"gcc -mx32" ...../configure x86_64- linux-gnu

that isnt what the page says.  it does say for glibc to do:
	CC=3D"x32-gcc -mx32 " CXX=3D"x32-g++ -mx32 " CFLAGS=3D"-O2 -g"  ../configu=
re

but it doesnt say what to do for binutils or gcc itself.  obviously you can=
t=20
use the -mx32 flag when building the cross gcc for the first time since the=
=20
current native gcc wont support it.

the invocation given for glibc implies that the proposed tuple is x32-linux-
gnu, but the GNU config project doesnt support that tuple and i didnt see=20
mention of it in the binutils or gcc sources.

so we get back to my original e-mail:
	are you getting a unique host tuple for this ?  or are you extending
	x86_64-linux-gnu ?  so the only way of knowing which ABI is to check for
	the output of the compiler+compiler flags ?
=2Dmike

--nextPart1480052.zWKNAQ7hHJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNgEmaAAoJEEFjO5/oN/WBQPMP/i2hJHBlmudiRaAWTMQoL3sS
EpoZrVUdKhtfBJyLIrH0bdT24NSsCgbbOj3GkxqHkNX5/6ikRkEFBCyyM+vGECHw
54Mtk0OaP2HrsmiItzZ4UMjlGOpGBsg4kCN1cpimRAdA7fJn2w2OSbVx4hqGE1BH
hALcz6V5IjiBJyyXr/0l0CQ0s77kzt/aQAh8GOMoIX9gEq7MLoap38kv5nRXqiWj
e3C7xfnkrGqWsepwVX6P1QeYLg7sWJimxRTbyEHe/MzFCmzX70yqdRjh18R4Hz/v
n7W8cid33EwLysBAisHYX6/zNOWT7j0IaWy9JKE8PR7N9CHjiM1AEoo6UkeLW4K9
URMgvJOvM3tAipnsTCXLh/J0OpHZDOLJuyy/qo2/41fqfOkbCYrKkJrGA7tMmDH8
aRC7zhm/JsltoQVbzv2+6SEZWRStC8CP548BKa3NJ8CDfr/dBdYXcY7YvuiczZPb
DXqjLz0Op9z2s+p/+H/KEdip84P54AWAtY7xjyR13J/dt6dJlrFOneJ3v0KDQV52
acalJl96g9KFHx/FFKqNHmAgQTP7vekJrwYxkeEQNuKUypZ25XvCZWIaIQwBEaH3
cEsRd5hnyzqa/teynX8TLhsQLw7hGQ0+EK9lC7OZEp0AKYgXvTgpgCDTSnVKwbLO
3UH/eEbbag5gmwCTXQT7
=Wq8Z
-----END PGP SIGNATURE-----

--nextPart1480052.zWKNAQ7hHJ--
