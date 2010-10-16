Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0JPN54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:57:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40379 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0JPN5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iUeF/cULZH65AQnc5HPm8Tbd+SYH7rUi4i+YKZVBtea/71T/uXLuVHB/lJFOkLYxVX
         MEY8t3/uYVM5AlMO53h6hhccLZRXlet1AsxhWPLTQRNXgVGdP7g7If6EGsl6XAGbAk4F
         3G0IVuCtL9ZtrMukiXwQM2+l7hBO42lbjpd2o=
From: Tracey Dent <tdent48227@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 01/02] Drivers: crypto: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:49:22 -0400
Message-Id: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/crypto/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 64289c6..2566973 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
-n2_crypto-objs := n2_core.o n2_asm.o
+n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
-- 
1.7.3.1.104.gc752e

