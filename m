Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab2JLQid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab2JLQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:29 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 6/9] Staging: winbond: wb35rx_f: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:12 +0530
Message-Id: <1350059835-5408-7-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl reported ERRORs

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wb35rx_f.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wb35rx_f.h b/linux-3.6-rc7/drivers/staging/winbond/wb35rx_f.h
index 1fdf65e..559bdca 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wb35rx_f.h
+++ b/linux-3.6-rc7/drivers/staging/winbond/wb35rx_f.h
@@ -4,12 +4,12 @@
 #include <net/mac80211.h>
 #include "wbhal.h"
 
-//====================================
-// Interface function declare
-//====================================
-unsigned char		Wb35Rx_initial(  struct hw_data * pHwData );
-void		Wb35Rx_destroy(  struct hw_data * pHwData );
-void		Wb35Rx_stop(  struct hw_data * pHwData );
+/*
+ * Interface function declaration
+ */
+unsigned char	Wb35Rx_initial(struct hw_data *pHwData);
+void		Wb35Rx_destroy(struct hw_data *pHwData);
+void		Wb35Rx_stop(struct hw_data *pHwData);
 void		Wb35Rx_start(struct ieee80211_hw *hw);
 
 #endif
-- 
1.7.7.3

