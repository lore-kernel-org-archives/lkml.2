Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1CPEaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:30:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56996 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1CPEaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:30:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Wed, 16 Mar 2011 00:30:26 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103071633.08197.vapier@gentoo.org> <AANLkTinu_FZ2_T4N7W9qNtoatG7zQua-SYSJ0GU0cJia@mail.gmail.com>
In-Reply-To: <AANLkTinu_FZ2_T4N7W9qNtoatG7zQua-SYSJ0GU0cJia@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1407405.j8Mm4vX3LF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103160030.27594.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1407405.j8Mm4vX3LF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 16, 2011 00:17:04 H.J. Lu wrote:
> On Mon, Mar 7, 2011 at 1:33 PM, Mike Frysinger wrote:
> > On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
> >> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
> >>=20
> >> https://sites.google.com/site/x32abi/
> >>=20
> >> The major remaining issues are glibc/gcc testsuite failures,
> >> kernel core dump and signal handler unwind.
> >=20
> > are you getting a unique host tuple for this ?  or are you extending
> > x86_64- linux-gnu ?  so the only way of knowing which ABI is to check
> > for the output of the compiler+compiler flags ?
>=20
> x32 requires x32 enabled x86-64 kernel.

ok, but that doesnt answer my question.  what are you passing to --target ?
=2Dmike

--nextPart1407405.j8Mm4vX3LF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNgDzjAAoJEEFjO5/oN/WBExgQAJ8bkb8ZI5Tq8bpRgGh0cS1q
/M4ZMfb+vV0RRHBilA4ZFinzUAT30AlPGgLMSCLrIjBpxoj1/4XehdLU44tT2+xB
f8uPcW22ReyUJPkvUHRT52yx15dUR/2BI03f1NUboNaLTfTBTZKUdvYUkwPg3/iP
NXCYlo5DPPzyRumNh7l+oJpcbFeheObptqq+O6FmutQO5TKvUWhnVbf/QdrZx6A4
UD3OO5V/bPN+C3aITqQYJBfDe5FFSPNRMOj430JlbkACYuIwTTy4pVVyhNTtopQh
/sv6LT/TpT1wd6zy5FoUoJTO5wwRPYRZXii++2bLlkJaAiPl7dShLwDsAyE1iCN8
FRhKBVyLN3B4WDpHWgTbwihYlrseHXkwGOHxEKeA1LZyTTBZmNdBn5bSjlyT3eb2
q9LedHu2m6hHM0qUETNEUjNm0+1QOX+OhakaU6K+7gGS8vrx1GDPKmeJYH2IRIu/
rlYmcD/M5XlexCEr/BrcE2ynPIXyxdORiRloRUJIbvmP14kCTXnKAPY0/hCpxAJV
PUjq6uEgqVguH8+cyrq2ntJojJFXlK9QXNO5NOkQ/MZxZpSQ706JSGeXRYsocvPT
SfXaCkRoQHSc57XsXGzc1eEA7oXj3fpc6ERgw5cTEn0RrS7gg+SMXW8K3ZjnJ9LW
PsbC4P40WYZ7Rg1InIuy
=NCJx
-----END PGP SIGNATURE-----

--nextPart1407405.j8Mm4vX3LF--
