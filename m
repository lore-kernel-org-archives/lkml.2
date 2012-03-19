Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030809Ab2CSGXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:23:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59646 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2CSGXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:23:09 -0400
Date: Mon, 19 Mar 2012 17:22:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mircea Gherzan <mgherzan@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the irqdomain tree with the arm tree
Message-Id: <20120319172254.78e16fcb56fef216cc8fafac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_17_22_54_+1100_EYGk=V_rYVU.VXSu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_17_22_54_+1100_EYGk=V_rYVU.VXSu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
arch/arm/Kconfig between commit 4755ccad6d53 ("ARM: 7259/3: net: JIT
compiler for packet filters") from the arm tree and commit 2378b56c3747
("ARM: kconfig: always select IRQ_DOMAIN") from the irqdomain tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 3795400,c857283..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -33,7 -31,8 +33,8 @@@ config AR
  	select GENERIC_IRQ_SHOW
  	select CPU_PM if (SUSPEND || CPU_IDLE)
  	select GENERIC_PCI_IOMAP
 +	select HAVE_BPF_JIT
+ 	select IRQ_DOMAIN
  	help
  	  The ARM series is a line of low-power-consumption RISC chip designs
  	  licensed by ARM Ltd and targeted at embedded applications and

--Signature=_Mon__19_Mar_2012_17_22_54_+1100_EYGk=V_rYVU.VXSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZtC+AAoJEECxmPOUX5FEEUgP/RI8UH3postxR5m8zciiBcgJ
TkdezqSvXjxYaKPJ0Z30q3kXp0NiTBGtGMRG5q5N9tKQ5ywFEtVhoCZOw2o4cLYt
3jGUksx9dvgjWHdkT+Whsd/uDTY95Ux77kmcheuQNyju+YmeIetP7tJXWEtKPoKw
wzXaKjOJQoS4IyxIoLaNCTkA3eBH0s0xv6EZM8NSCOtcBODKOiAJ66y7t+SNQrOO
oMw0DJNAIKac7AbUZh4odaEUysZAO0nh2MdYeg7oQW25hdKOHxTUhPxmHNZ+PdN9
XHYoSulJdzIrQsvnk0TnweRvBClnIIcfSUdQhN/oFI++AW4YFTEXDJFeJqnipjHY
GyrhwBdKtP9FQJFdS3Da9hJ4AuR0+kO/GVG0rn/RuH0SC4OzBRR4vjFPKy3X5xId
MB2csBrvzBGOlgK8keu2rIKoqCCHUyvG7EW/Da5ulTjNGtDzBh097C7gHnr6KmYb
fbNkhWi+rXXwOIlwbIkODfLOlLiXSTEm2F1wc8wWVVsT39MxssaVhtP7ZOY/jFyl
KcFBsV4obq7+AzwTSsBBI3qLFshH6MsTRCRk16Q1l4SF33Ab730G2W+bMQaibCe1
4xg+UEYfekzEFxCBETWTH7axyvZyedKpjcFp1R6CRRytZ6PdppfG6hGjFmqUNz3Y
iYMcenDXWAZNUFWkSvcA
=Azt/
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_17_22_54_+1100_EYGk=V_rYVU.VXSu--
