Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0DZJbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:31:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:59193 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751010Ab0DZJbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:31:24 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX187lrZk0Qs7klf1EAr0EOtBwq5ANL3uOEXC2iFJcv
	Zz0cw4O/sVEbFj
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Range of 24/32 bit for atomic_t since 2.6.3
Date: Mon, 26 Apr 2010 11:31:19 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-3-amd64; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1373082.otb4QLlisk";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201004261131.20178.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1373082.otb4QLlisk
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

currently arch/mn10300/include/asm/atomic.h and include/asm-generic/atomic.=
h=20
warns right before atomic_read/atomic_set/atomic_add_return/ atomic_sub_ret=
urn=20
that atomic_t only guarantees a useful range of 24 bits.=20
Documentation/atomic_ops.txt informs about the historical reason why this w=
as=20
true for 32-bit Sparc - something that was changes in linux 2.6.3 using a h=
ash=20
array with spinlocks [1].

Is it save to assume that atomic_t provides us the full range of 32 bit aft=
er=20
2.6.3 and can those statements in both atomic.h be removed?

Kind regards,
	Sven Eckelmann

[1] http://lwn.net/Articles/71732/

--nextPart1373082.otb4QLlisk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJL1V1nAAoJEF2HCgfBJntG/9gP/2xkV8/daPwEOhczZba2Mpqs
Shon/ZfAUMyJP0CTgqmeiNz1siYcKDr9CyNEiDKpHHCiAivvJv7/GxBtrmr3tAUh
EH17FOzXflt2YtYwmpCz46L2LlaFTUZRkAFh17jqpBzFd1KqMsPw5Dyl/sYcNYjE
OakT/itqskkxyuDnpljuHKSZGfmar1EjAkmpkTsQVDkQCzA7wgoqqmQGChooP0Bs
eBX/ZOyKMyW15Z06Hq1WuKADGvXN/BhTM1h3l1BaP2ZMDHNw3CRscxq1S3CMr1ja
2NtTL4vMvy+w8uE1gaOUsJbGwDYAFDz6o3hIbdozxIDaZ4PTa/FP8TwcyjsfZoDW
ty7OLafm5ZYe2FE4qLEV41kzNsKBpnhuC6L4vZqBuR+grCpjY3ihzKpRxZ7uoq0u
Y2xPX26PLdMab045NdrhoubsYWS87z79r971kXWp70RgtOryHFnQ03ygXYsEksJt
CGxkwoBZodxEVhF3GkEgHwV1mkBaISK4p7kIrpyUTa3HE1nM/v9eK9bOmASpNRo6
wrN+9myOmF8PQuUKXviSaT3rx4hc1fjLsiT4iiJCtNdO7hEQBpezwOBrbZ8XRl+l
ahwMH3pzMNHHUimC1pEfb2wzmKC3dLDqW4Rb6Lc/NwcpEjvzRx+gFFjiMJH/NMl0
dgOASMAz3qeRCWV9nQ9Q
=CcWx
-----END PGP SIGNATURE-----

--nextPart1373082.otb4QLlisk--
