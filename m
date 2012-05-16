Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966237Ab2EPIvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:51:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37375 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab2EPIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:50:58 -0400
Date: Wed, 16 May 2012 18:50:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120516185045.2f9e9274f373d584fd499eb2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_18_50_45_+1000_vNz9c6Paf6MEKGuK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_18_50_45_+1000_vNz9c6Paf6MEKGuK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig between commit 98fab064d321 ("ARM: Remove unnecessary
selection of TICK_ONESHOT") from the arm tree and commit c24b31147a06
("ARM: mmp: support DT in irq") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index b1a717c,852b12b..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -627,6 -616,8 +611,7 @@@ config ARCH_MM
  	select CLKDEV_LOOKUP
  	select GENERIC_CLOCKEVENTS
  	select GPIO_PXA
+ 	select IRQ_DOMAIN
 -	select TICK_ONESHOT
  	select PLAT_PXA
  	select SPARSE_IRQ
  	select GENERIC_ALLOCATOR

--Signature=_Wed__16_May_2012_18_50_45_+1000_vNz9c6Paf6MEKGuK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs2plAAoJEECxmPOUX5FENNEP+gNvkkL/StcBzc+izleVFKEv
7a1PpNKUPGKklZdrpDZM43E6OPTubXoCI1zNgJvT/PS81rR8nbRPNYbqSOqiva9U
fcZkFfkqJ+/xevN91lOjFiRy2rtYG5bY5LIZlLyJYsvQGLAer0rqTviGJSWANeoy
gG74fDcyAQ3sDWWgiUIsyM4jsXZP0cukQLv6SMKHP7md7B5twTTOKbd12qkEKKTn
7mr6EgzZroeFI4jOWy4KbCsAKR4EIZy+L2a0iVo+fr1sJkN094jdfD6UclnzJUMd
Y+jWb+zz1MAQOaz4o0qGQ6sBj6WE45UqIFIDpMWXutOMKOlv9YCojjfd8eWNisbZ
l+T6R7sgKaapayyQL71L6/BkTQtklgnlImpwcmsnab50bIkp3xdaoFqiBHU6sEPC
kWZ+ZIFg7WIjq4J5b9O63B4PmdVWWCnYwMczZrWgzWrNhp1NubWnJ29kQ7xcMsEj
LciAguqdObIwiiuMX4Q7JZPjKdInl4CY3ysIIXj48XiBF7WbNPXhc1ORPA6p++fs
FgRNfrAMbjWH+vFrvHF2U9v3t7kLafB+Cuzwa8/I9TGGgl94lxhrTtwsfSHFh5Kh
+U0ckKOhlqtvPzsmtx4Mh0tdTOQFx6tNeRqoR9G2UPOCsqaCKAPTh1fenMBAjs9j
Yo5U1oYUjeFXJ4h6aOND
=bT3W
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_18_50_45_+1000_vNz9c6Paf6MEKGuK--
