Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0F1Lz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0F1Lzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PxUXMpJ2MRtY6T8HxutDvNOOg+hmeiubvwtiSJ8KFyv43vtredCCLj1fUS8kui1NnU
         KHbt5X/s1qrKRv72IZUGCYA9cZXjQeDVas0FIGI7FU7pYPy0EChQ1ILfRRCjMywjAeow
         1KbAaxQrz/TyZg6xSXJMw4jiVuSLTKiHST7dU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kulikov Vasiliy <segooon@gmail.com>, Henk de Groot <pe1dnn@amsat.org>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:41 +0400
Message-Id: <1277726143-24899-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/wlags49_h2/hcf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 390628c..c4fe0ec 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -502,7 +502,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
 #endif // MSF_COMPONENT_ID
 	NULL									//endsentinel
   };
-#define xxxx_PRI_IDENTITY_OFFSET	(sizeof(xxxx)/sizeof(xxxx[0]) - 3)
+#define xxxx_PRI_IDENTITY_OFFSET	(ARRAY_SIZE(xxxx) - 3)
 
 #endif // MSF_COMPONENT_ID / HCF_EXT_MB
 
-- 
1.7.0.4

