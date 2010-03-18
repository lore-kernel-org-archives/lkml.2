Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0CRP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:57:39 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:35126 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0CRP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:57:37 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmZBAK7qoUtT4vpWPGdsb2JhbACHYJNMDAEBAQE3LawTjW2EeQQ
X-IronPort-AV: E=Sophos;i="4.51,267,1267398000"; 
   d="scan'208";a="52722215"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
Date: Thu, 18 Mar 2010 16:57:37 +0100
Message-Id: <1268927857-14141-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed all problems found by checkpatch.pl and removed CamelCase
from argument names.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mlmetxrx_f.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 6c04e3e..02dfd46 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -1,25 +1,26 @@
-//================================================================
-// MLMETxRx.H --
-//
-//   Functions defined in MLMETxRx.c.
-//
-// Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
-//================================================================
+/* ================================================================
+ * MLMETxRx.H --
+ *
+ *   Functions defined in MLMETxRx.c.
+ *
+ * Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
+ * ================================================================
+ */
 #ifndef _MLMETXRX_H
 #define _MLMETXRX_H
 
 #include "core.h"
 
-void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
+void MLME_GetNextPacket(struct wbsoft_priv *adapter,
+			struct wb35_descriptor *pdes);
 u8 MLMESendFrame(struct wbsoft_priv *adapter,
-		 u8 * pMMPDU, u16 len, u8 DataType);
+		 u8 *pmmpdu, u16 len, u8 datatype);
 
-void
-MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
-		  unsigned char SendOK);
+void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packetid,
+			unsigned char sendok);
 
 #ifdef _IBSS_BEACON_SEQ_STICK_
-s8 SendBCNullData(struct wbsoft_priv *adapter, u16 wIdx);
+s8 SendBCNullData(struct wbsoft_priv *adapter, u16 widx);
 #endif
 
 #endif
-- 
1.7.0.2

