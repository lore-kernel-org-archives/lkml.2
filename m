Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1ISGTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:19:11 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39434 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1ISGTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:19:09 -0400
Date: Mon, 19 Sep 2011 16:19:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20110919161900.99b51989c9a02075e9f4cc93@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2011_16_19_00_+1000_yP30zhevtaqrjYuJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Sep_2011_16_19_00_+1000_yP30zhevtaqrjYuJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/regulator/mc13783-regulator.c: In function 'mc13783_regulator_probe=
':
drivers/regulator/mc13783-regulator.c:347:9: error: dereferencing pointer t=
o incomplete type
drivers/regulator/mc13783-regulator.c:355:23: error: dereferencing pointer =
to incomplete type
drivers/regulator/mc13783-regulator.c:356:21: error: dereferencing pointer =
to incomplete type
drivers/regulator/mc13783-regulator.c:358:34: error: dereferencing pointer =
to incomplete type
drivers/regulator/mc13783-regulator.c:359:26: error: dereferencing pointer =
to incomplete type
drivers/regulator/mc13783-regulator.c: In function 'mc13783_regulator_remov=
e':
drivers/regulator/mc13783-regulator.c:390:23: error: dereferencing pointer =
to incomplete type

Caused by commit a7e5c9a30148 ("mfd: Remove mc13783 API functions and
symbols").

I have used the mfd tree from next-20110915 again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Sep_2011_16_19_00_+1000_yP30zhevtaqrjYuJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOdt7UAAoJEDMEi1NhKgbsTYoIAJz8IVSqQXCp7Yi7tXgoH57h
f+AUPjudg1egQbZp15PUfhpDbLrbQlPYhcsp9UyRFBuumDRQguidt+tbMQ0ZP1Aj
nLeCl8EBPVM999KNeVNs76QrY73L9buSZFzQ3pi2vdQrEOJ53K90yU8Gxufc0i4Y
CahGCN3LUu3uZjRZJzpI1qTq+pEw4Oamv9LmTMMR2fgu37TDMuq2VKnYkEgkdSUF
3thhEPdcmHvsZfPo+voBFTQKzbz0JsFPYDsoGaHiCTv7Mzf1xuzd4JVKunPDwQZY
texf+imWhU5NiQYr7JPVLVVZ2RHpD9o1pndhjPtONPBmxwPFTyI/tT+kWSSY6Ig=
=S7Yc
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2011_16_19_00_+1000_yP30zhevtaqrjYuJ--
