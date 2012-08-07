Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2HGMDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:03:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60704 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2HGMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:03:41 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: davem@davemloft.net, herbert@gondor.hengli.com.au, patches@linaro.org,
        Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH] crypto: atmel - Remove possible typo error
Date: Tue,  7 Aug 2012 17:32:14 +0530
Message-Id: <1344340934-1319-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bd3c7b5c2aba ("crypto: atmel - add Atmel AES driver") possibly
has a typo error of adding an extra CONFIG_.

CC: Nicolas Royer <nicolas@eukrea.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7d74d09..26d7d67 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -340,7 +340,7 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
-	select CONFIG_AT_HDMAC
+	select AT_HDMAC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
1.7.4.1

