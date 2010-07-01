Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0GALXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:23:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0GALXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MFm1jiOotm0LTtgqOAgiKHy21Nv9yYxmzNqGTJ7LwKQ/qZY69px+DxhRJBWozayghn
         22bu7DBcFyCj6X1zxbBv2cLvlpjg2+1kQ2NE7idafk/5BXYVLXxMnrcIXfLPYESXZGnU
         XDPumICPqxZ0Wk0KeVHSs35RMdhWA6+KjVv80=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] staging/wlags49_h2: use ARRAY_SIZE
Date: Thu,  1 Jul 2010 15:23:08 +0400
Message-Id: <1277983390-30164-1-git-send-email-segooon@gmail.com>
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

