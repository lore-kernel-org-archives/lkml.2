Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2FMSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:25:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38529 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FMSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:25:26 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        trivial@kernel.org, Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH 2/2] drivers: crypto: fix typo in nx driver config option
Date: Wed, 13 Jun 2012 13:22:43 -0500
Message-Id: <1339611763-14603-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061318-7408-0000-0000-000005D322FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1092a77..b9b11a6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -298,7 +298,7 @@ config CRYPTO_DEV_TEGRA_AES
 	  will be called tegra-aes.
 
 config CRYPTO_DEV_NX
-	tristate "Support for Power7+ in-Nest cryptographic accleration"
+	tristate "Support for Power7+ in-Nest cryptographic acceleration"
 	depends on PPC64 && IBMVIO
 	select CRYPTO_AES
 	select CRYPTO_CBC
-- 
1.7.9.5

