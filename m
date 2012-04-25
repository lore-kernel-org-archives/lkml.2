Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2DYAX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:23:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57561 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2DYAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:23:55 -0400
Date: Wed, 25 Apr 2012 10:23:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
Message-Id: <20120425102342.45cf5c5e81e8aeb3bec67d0b@canb.auug.org.au>
In-Reply-To: <20120424162224.526249106@chello.nl>
References: <20120424161039.293018424@chello.nl>
	<20120424162224.526249106@chello.nl>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Apr_2012_10_23_42_+1000_CWhLpARWOjpb46q0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Apr_2012_10_23_42_+1000_CWhLpARWOjpb46q0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Tue, 24 Apr 2012 18:10:41 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
>
> Grow rudimentary u128 support without relying on gcc/libgcc.
>=20
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/alpha/include/asm/math128.h      |    4 ++
>  arch/arm/include/asm/math128.h        |    4 ++
>  arch/avr32/include/asm/math128.h      |    4 ++
>  arch/blackfin/include/asm/math128.h   |    4 ++
>  arch/c6x/include/asm/math128.h        |    4 ++
>  arch/cris/include/asm/math128.h       |    4 ++
>  arch/frv/include/asm/math128.h        |    4 ++
>  arch/h8300/include/asm/math128.h      |    4 ++
>  arch/hexagon/include/asm/math128.h    |    4 ++
>  arch/ia64/include/asm/math128.h       |    4 ++
>  arch/m32r/include/asm/math128.h       |    4 ++
>  arch/m68k/include/asm/math128.h       |    4 ++
>  arch/microblaze/include/asm/math128.h |    4 ++
>  arch/mips/include/asm/math128.h       |    4 ++
>  arch/mn10300/include/asm/math128.h    |    4 ++
>  arch/openrisc/include/asm/math128.h   |    4 ++
>  arch/parisc/include/asm/math128.h     |    4 ++
>  arch/powerpc/include/asm/math128.h    |    4 ++
>  arch/s390/include/asm/math128.h       |    4 ++
>  arch/score/include/asm/math128.h      |    4 ++
>  arch/sh/include/asm/math128.h         |    4 ++
>  arch/sparc/include/asm/math128.h      |    4 ++
>  arch/tile/include/asm/math128.h       |    4 ++
>  arch/um/include/asm/math128.h         |    4 ++
>  arch/unicore32/include/asm/math128.h  |    4 ++
>  arch/x86/include/asm/math128.h        |    4 ++
>  arch/xtensa/include/asm/math128.h     |    4 ++
>  include/linux/math128.h               |   47 +++++++++++++++++++++++++++=
+++++++

Isn't this what asm-generic is for?  You put the generic version in
asm-generic/math128.h and then add "generic-y +=3D math128.h" to
arch/*/include/asm/Kbuild for each arch that wants the generic version.
Then just include asm/math128.h in linux/math128.h.  Any arch that wants
to optimise these can then just provide its own math128.h.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Apr_2012_10_23_42_+1000_CWhLpARWOjpb46q0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPl0QOAAoJEECxmPOUX5FELGcP/2Q0mXijapkUQ1T7HbmT8ZXn
KxwHFpBT7WRx1FQk6PRrs9V4H10KAwUC259GcbYG+Aj/n41xXnS5l8Zs5ZAfQndj
myGqOD+WBeHeEVwuMTr4tXJV4olI+1Dc68/rBEvsikimh9cXQvuBHeoW/Tnnt3+0
PbZT+Xgw3NvEXgp2N8vQid/a36eJxziqSqjlD527sbzUzgkjwFRNGxGuE7lg0DUB
yUSiBAlD6H+nDJqRCQVChDa626p6GKseXRRvcJm6vOrQMHmUV/jkJJWbSMQiUKTX
Rspox30YOK6cOE8RK6W6Y7j9a13jDItpZXYu13F0LG+ZFyBmH3URcSmjHfvor6R4
qQU+MGpl+CDIY7wiYj2HHVJiRGZU+B5engdWQ6XEgv7vCbSVWVEj5RzwlMW/kwmU
J3G6rcFHL8SujD8lJpA/uveOYb2WGT7AWFMtDACibS6s2/NkkZfK549PnNgK4FXv
259kpR6L4y8M81Og5Ko48ZB0KXUF2mEx7CQsco9h//gAx8Rb5+gP1Aq5AN0i0X20
6KrB5vRfdrBTalDG/czWiJPCinrl65DSdjvNHZx15ApYR4L9OpFigMsIAgehyqqs
iDVQO3POBBdVGrleGG1MbcZMe9eU3LvFju1/S6w6xLdxjQFY8pdzXrQrY+oGUcV6
8mL2adTrnm+ds9ifhZBg
=EFrt
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Apr_2012_10_23_42_+1000_CWhLpARWOjpb46q0--
