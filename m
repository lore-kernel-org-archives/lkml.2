Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1KIG3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:29:35 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37912 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1KIG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:29:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH V2] fix typo in crypto/Kconfig
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 09 Nov 2011 01:29:20 -0500
Message-ID: <20111.1320820160@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4EBA1DC4.0081,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in the Kconfig file help text.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
Third time's the charm? Rebased to next-20111108 ("depends on NET"
caused the first 2 tries to not appy).

--- linux-next/crypto/Kconfig.dist	2011-11-06 01:35:20.423166379 -0400
+++ linux-next/crypto/Kconfig	2011-11-09 01:21:15.325935266 -0500
@@ -105,7 +105,7 @@ config CRYPTO_USER
 	depends on NET
 	select CRYPTO_MANAGER
 	help
-	  Userapace configuration for cryptographic instantiations such as
+	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_MANAGER_DISABLE_TESTS

