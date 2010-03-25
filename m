Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CYVWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:22:22 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:56149 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0CYVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:22:21 -0400
X-SENDER-IP: [83.226.248.110]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoE8AE5xq0tT4vhuPGdsb2JhbACHcZM3DAEBAQE3LbE1jXmEfQQ
X-IronPort-AV: E=Sophos;i="4.51,309,1267398000"; 
   d="scan'208";a="55725106"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35rx_f.h Coding style fixes.
Date: Thu, 25 Mar 2010 22:21:57 +0100
Message-Id: <1269552117-4343-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed comments and whitespace and converted the function arguments
away from hungarian notation and camelcase.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35rx_f.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 98acce5..928e818 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -4,12 +4,13 @@
 #include <net/mac80211.h>
 #include "wbhal_s.h"
 
-//====================================
-// Interface function declare
-//====================================
-unsigned char		Wb35Rx_initial(  struct hw_data * pHwData );
-void		Wb35Rx_destroy(  struct hw_data * pHwData );
-void		Wb35Rx_stop(  struct hw_data * pHwData );
+/*
+ * ====================================
+ * Interface function declare
+ *====================================
+ */
+unsigned char	Wb35Rx_initial(struct hw_data *hw_data);
+void		Wb35Rx_destroy(struct hw_data *hw_data);
+void		Wb35Rx_stop(struct hw_data *hw_data);
 void		Wb35Rx_start(struct ieee80211_hw *hw);
-
 #endif
-- 
1.7.0.3

