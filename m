Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0H0BOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:14:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55360 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0BOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:14:11 -0400
Date: Fri, 27 Aug 2010 11:14:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100827111400.58bf82d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Aug_2010_11_14_00_+1000_8dEXRpqSHJ3=dM=T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Aug_2010_11_14_00_+1000_8dEXRpqSHJ3=dM=T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the nert tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/stmmac/stmmac_timer.c: In function 'stmmac_open_ext_timer':
drivers/net/stmmac/stmmac_timer.c:60: error: 'CONFIG_RTC_HCTOSYS_DEVICE' un=
declared (first use in this function)

Maybe exposed by commit ac75791aa943c7953521cb4fa7728bf51f9abd2d ("stmmac:
remove dead option in the driver's Kconfig") since presumably we used to
not build this driver.

I have used the net tree from next-20100826 (with the 2 reverts) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Aug_2010_11_14_00_+1000_8dEXRpqSHJ3=dM=T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdxFYAAoJEDMEi1NhKgbsrRwH/3V+p6pcvpDIOZxjMWIAsKRF
uy4o+ysnHqfnJKw8yauk+hYOV0ztpHjBVxjVjjvOpOCgsMg7tuKzWvNQ00VwrdDw
ea6uFmphk3zJ4K84AXBzOGam5WYGk4pLfrMhqYN0z8SdTbri8O8LamYRypdzWyyG
7OUgIMU/fSOPUK8xEj+dPhir0pup+XLOtxnWOj2/tuXhl7tlwClJwlwutZZXhwTg
YBy5a4Mx1g1i8VeJdsQclQzxy439q9KBDJFm1nbmIkc/O5blTMPuKvc8DuTtu3/E
z5g6jRSKXp+E+HBE2fx5U9ciAEANOcd64lLT0f8Zx0yFZonNZWLZGoiYde1AeEc=
=brKZ
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Aug_2010_11_14_00_+1000_8dEXRpqSHJ3=dM=T--
