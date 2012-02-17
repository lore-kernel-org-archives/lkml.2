Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2BQEiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:38:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42355 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2BQEiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:38:01 -0500
Date: Fri, 17 Feb 2012 15:37:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>, Mark Salter <msalter@redhat.com>
Subject: linux-next: manual merge of the irqdomain tree with the arm tree
Message-Id: <20120217153749.5d77fe6bc877a0f1f4e94855@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_15_37_49_+1100_ZtYAXoXnOEoUjJyk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_15_37_49_+1100_ZtYAXoXnOEoUjJyk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
arch/c6x/Kconfig between commit 2ed86b16eabe ("irq: make SPARSE_IRQ an
optionally hidden option") from the arm tree and commit 0bd761e1b6d9
("irq_domain/c6x: Convert c6x to use generic irq_domain support") from
the irqdomain tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/c6x/Kconfig
index 2f58c61,3c64b28..0000000
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@@ -11,7 -11,8 +11,8 @@@ config TMS320C6
  	select HAVE_DMA_API_DEBUG
  	select HAVE_GENERIC_HARDIRQS
  	select HAVE_MEMBLOCK
 -	select HAVE_SPARSE_IRQ
 +	select SPARSE_IRQ
+ 	select IRQ_DOMAIN
  	select OF
  	select OF_EARLY_FLATTREE
 =20

--Signature=_Fri__17_Feb_2012_15_37_49_+1100_ZtYAXoXnOEoUjJyk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPdmdAAoJEECxmPOUX5FEfiUP/1Lj60kKU+xbHsKfhwTazfQ+
bXcYs8MNm94KnM/iZlr6pftcX/FmqvUHW+bwiwuEy9knxX1qcB+JL5U73qbyd2FT
cVjs1aIa5bnm+b1KwWOv6XLPY6wTPac//JW+wYQWNcobXTq7ZmOweovB3gb0EYXW
vOpGjuABtLl2svgq0a/+oW0TeOyjsnESVU6chQX7dYzxlOqQhxyF8HLelJfZOx5F
1t8a4rmZ/AHQMStwclPC4mNuvsvOJRTkPQiCEy1xGFHhsu6yG69rwpRy/wItDFJK
CA2bNtkqvPDadK6gjgyJyul+rpvfTSGM3hQGP8TrE2HWPRDczdksnoAdXy5tVcM7
bWVOwVvJDYwPTCK+jM4yy1KB4gk3ZD407PDCld+JXTFwqgEYtOM9SCVu2JOWLUzC
moXKWfEQrrT+EmQarDnNdM+rwAwZ2Pv8drhT32t/3VQ2p8LBMslHFRNH+3IA6GKv
c93ZHPjynR0wkbHmHDeioJrXg3gl5AY6Tn8cbpMD3p1UCkjTfSW47taOJMHuT+nG
vcWw2WCJ90LyiQ6DW4z5rN8PpfTeNy0fQ/w4lYpFejh05QGcaUzKl8XOCUd6xSiN
pcWArIx7Eo7hO3mMCnYxXnmJcINYnlunlvBhWHE9StOs+eDAUvuLGJRdxD52tGfy
vhfAF+0cYf6Ccs4LuJDE
=eqqh
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_15_37_49_+1100_ZtYAXoXnOEoUjJyk--
