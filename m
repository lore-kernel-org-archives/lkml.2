Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1K2DXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:23:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39951 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1K2DXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:23:09 -0500
Date: Tue, 29 Nov 2011 14:22:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Kuo <rkuo@codeaurora.org>
Subject: linux-next: manual merge of the vhost tree with the hexagon tree
Message-Id: <20111129142259.78d3e10678c8e9d8376d52aa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_14_22_59_+1100_IZPZ3tB7bMZaxAFU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_14_22_59_+1100_IZPZ3tB7bMZaxAFU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
arch/hexagon/Kconfig between commit 5237bae0d8c9 ("various Kconfig
cleanup and old platform build code removal") from the hexagon tree and
commit4673ca8eb369  ("lib: move GENERIC_IOMAP to lib/Kconfig") from the
vhost tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/hexagon/Kconfig
index a35ec47,9059e39..0000000
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@@ -24,7 -26,8 +24,8 @@@ config HEXAGO
  	select HAVE_ARCH_KGDB
  	select HAVE_ARCH_TRACEHOOK
  	select NO_IOPORT
 +	select STACKTRACE_SUPPORT
+ 	select GENERIC_IOMAP
 -	# mostly generic routines, with some accelerated ones
  	---help---
  	  Qualcomm Hexagon is a processor architecture designed for high
  	  performance and low power across a wide variety of applications.
@@@ -71,9 -74,15 +72,6 @@@ config GENERIC_CSU
  config GENERIC_IRQ_PROBE
  	def_bool y
 =20
- config GENERIC_IOMAP
- 	def_bool y
-=20
 -#config ZONE_DMA
 -#	bool
 -#	default y
 -
 -config HAS_DMA
 -	bool
 -	select HAVE_DMA_ATTRS
 -	default y
 -
  config NEED_SG_DMA_LENGTH
  	def_bool y
 =20

--Signature=_Tue__29_Nov_2011_14_22_59_+1100_IZPZ3tB7bMZaxAFU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1FATAAoJEECxmPOUX5FEfK0P/1xcdJOQOe2uee80yAPx5VQE
IYNWO11mtcTxoSBIyKiU0i3x7F5G49F3pLQB23WBexsqKS80nYr4+KWh4EW6ZKz8
NeJ5GSR8x67CEyCVEP7KgDl99cI2XvAL44E30E5ePB/gPu/zwDK1iRiqr2oV6Dve
5U9JcWdZ7JRYnXSB1g668ZsWDKFECkedT88QA1kkD62PysDjCRobLOPBNI27R0YR
CJQdrFd0vnZBHSYnjIFE1c32Rau84/9HAw+He5hS2InioBoW0DIYFWaw1Jwmybgh
F1gRtcVdnt2oo9KmLc06HtV4fUuVhD7CGbYgwVp1hXDVfxTk57aBQu81ZNeD0pdp
Tg1lY7Al1iJFawJqfgokuTy/WncQt1HRlTERxr8Z//OpphwAZGUtILKKZ7Y39UBv
YXqyv9DwfCiDxDAF8ZzUqVZloM4HfSmCfYAv+rNIVCSPMpMHEQSSFQDLECPgildD
kfFqDFiF5Mnwo2zIVlU9t2rH5MEKtKfdMGtD6Gs6T4k63gAvhc+6QARGF1xJv5yD
a+739KrEQbVatI8OmZCMIeqclTyljkOhUzvyMdbA3gRIebWxbnifRGBY21+uYs0n
GuLxZwr55HiRIJu0Qygs8+ZQqeprkKyAPw44+mLlArhzYEcL/VUfHBq9iDyzi+Wi
JzMLmyf9PEFa4wXnL/Rt
=8iJN
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_14_22_59_+1100_IZPZ3tB7bMZaxAFU--
