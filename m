Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1ITVLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:11:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35216 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ITVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:11:15 -0400
Date: Wed, 21 Sep 2011 07:11:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH -next v2] bcma: driver_chipcommon_pmu.c needs
 linux/export.h
Message-Id: <20110921071103.b4faaa4648ec3c09a4505ab1@canb.auug.org.au>
In-Reply-To: <4E78FCDB.1010002@xenotime.net>
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
	<4E78CFC0.4020003@xenotime.net>
	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
	<4E78FCDB.1010002@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Sep_2011_07_11_03_+1000_Cd=aur2Hxw/4KxLk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Sep_2011_07_11_03_+1000_Cd=aur2Hxw/4KxLk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 20 Sep 2011 13:51:39 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>
> to fix these warnings:
>=20
> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: data definition has n=
o type or storage class
> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: type defaults to 'int=
' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: parameter names (with=
out types) in function declaration
> drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: data definition has n=
o type or storage class
> drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: type defaults to 'int=
' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: parameter names (with=
out types) in function declaration
> drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: data definition has n=
o type or storage class
> drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: type defaults to 'int=
' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: parameter names (with=
out types) in function declaration
> drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: data definition has n=
o type or storage class
> drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: type defaults to 'int=
' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: parameter names (with=
out types) in function declaration
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

I have added this to my collection of merge fixups for the moduleh tree
(since linux/export.h doesn't exist in Linus' tree, yet).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Sep_2011_07_11_03_+1000_Cd=aur2Hxw/4KxLk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeQFnAAoJEDMEi1NhKgbs+10H/1AQ3BFgi/cfBF8EE6vrfYS/
S4FA3IMi4/u/SSvpsDQUwbwE0YrDdYIU0DkCsEMEGaZ3zUiaUV8VXW+Q5HAg961t
mLjjXhS2cyYsyw+VsTpLUG22tYNfU3zydfk/yTxIcl4gRpIbpXz1JYkO2vtyfAHP
BBuS6W0cqkMY7b/ygNtXbh/rmIL5VDcTjhFMZBxNanrpVsMCRfS3CNp9LycCyNxb
lSFkEx4b9/gSZmyBUZKAEUAP/2iyoS/r1mg9sU6nvAaFVHV/0oiaZ2bXrYRL5y/Y
93pfGPnkmZK+D53ItJadFfj/40CFXH8Xm23KYWoY1wmKaUy5ThR2z8azNvrFnDQ=
=VrL6
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Sep_2011_07_11_03_+1000_Cd=aur2Hxw/4KxLk--
