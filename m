Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2E0Uym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:54:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46183 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2E0Uyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:54:40 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] [staging] bcm: Fix codingstyle problems
Date: Mon, 28 May 2012 02:24:34 +0530
Message-Id: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/bcm/Debug.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
index 420382d..9b5ab4b 100644
--- a/drivers/staging/bcm/Debug.h
+++ b/drivers/staging/bcm/Debug.h
@@ -240,16 +240,16 @@ typedef struct _S_BCM_DEBUG_STATE {
 		print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,	\
 			       16, 1, buffer, bufferlen, false);	\
 	}								\
-} while(0)
+} while (0)
 
 
 #define BCM_SHOW_DEBUG_BITMAP(Adapter)	do { \
 	int i;									\
-	for (i=0; i<(NUMTYPES*2)+1; i++) {		\
+	for (i = 0; i < (NUMTYPES * 2) + 1; i++) {		\
 		if ((i == 1) || (i == 2) || (i == 4) || (i == 8)) {		\
 		/* CAUTION! Forcefully turn on ALL debug paths and subpaths!	\
 		Adapter->stDebugState.subtype[i] = 0xffffffff;	*/ \
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "subtype[%d] = 0x%08x\n", 	\
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "subtype[%d] = 0x%08x\n",	\
 		i, Adapter->stDebugState.subtype[i]);	\
 		}	\
 	}		\
-- 
1.7.9.5

