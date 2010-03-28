Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0C1H54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 03:57:56 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:33078 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab0C1H5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 03:57:55 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkszACyprktT4vnEPGdsb2JhbACHZ5NADAEBAQE1La8BjQqFAQQ
X-IronPort-AV: E=Sophos;i="4.51,321,1267398000"; 
   d="scan'208";a="56562593"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35tx_f.h Coding style fixes.
Date: Sun, 28 Mar 2010 08:57:55 +0200
Message-Id: <1269759475-4920-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the checkpatch.pl problems and converted the function
arguments away from CamelCase and hungarian notation.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35tx_f.h |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx_f.h b/drivers/staging/winbond/wb35tx_f.h
index a7af9cb..1d3b515 100644
--- a/drivers/staging/winbond/wb35tx_f.h
+++ b/drivers/staging/winbond/wb35tx_f.h
@@ -4,18 +4,20 @@
 #include "core.h"
 #include "wbhal_f.h"
 
-//====================================
-// Interface function declare
-//====================================
-unsigned char Wb35Tx_initial(	 struct hw_data * pHwData );
-void Wb35Tx_destroy(  struct hw_data * pHwData );
-unsigned char Wb35Tx_get_tx_buffer(  struct hw_data * pHwData,  u8 **pBuffer );
+/*
+ * ====================================
+ * Interface function declare
+ * ====================================
+ */
+unsigned char Wb35Tx_initial(struct hw_data *hw_data);
+void Wb35Tx_destroy(struct hw_data *hw_data);
+unsigned char Wb35Tx_get_tx_buffer(struct hw_data *hw_data, u8 **buffer);
 
 void Wb35Tx_EP2VM_start(struct wbsoft_priv *adapter);
 
 void Wb35Tx_start(struct wbsoft_priv *adapter);
-void Wb35Tx_stop(  struct hw_data * pHwData );
+void Wb35Tx_stop(struct hw_data *hw_data);
 
-void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter,  u32 TimeCount);
+void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 time_count);
 
 #endif
-- 
1.7.0.3

