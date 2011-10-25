Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1JYLHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:07:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48071 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1JYLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:07:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] fix typo in crypto/Kconfig
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319540838_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 07:07:18 -0400
Message-ID: <27363.1319540838@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EA6986A.00E9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319540838_3131P
Content-Type: text/plain; charset=us-ascii

Fix a typo in the Kconfig file help text.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-next/crypto/Kconfig.dist	2011-10-25 06:57:29.413596040 -0400
+++ linux-next/crypto/Kconfig	2011-10-25 07:01:51.518647308 -0400
@@ -104,7 +104,7 @@
 	tristate "Userspace cryptographic algorithm configuration"
 	select CRYPTO_MANAGER
 	help
-	  Userapace configuration for cryptographic instantiations such as
+	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_MANAGER_DISABLE_TESTS


--==_Exmh_1319540838_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpphmcC3lWbTT17ARAiojAJ9xGtiMJrsIB06pLHHi8YgK7+wNBgCgzNfy
BRiflJemi1Lf4zz0nkzLuNU=
=z8QE
-----END PGP SIGNATURE-----

--==_Exmh_1319540838_3131P--

