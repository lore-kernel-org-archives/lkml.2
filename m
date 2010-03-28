Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0C1T5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:57:01 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:47959 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0C1T5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:57:00 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQ5APJQr0tT4vnEPGdsb2JhbACHaJNADAEBAQE1La9gjHuFAQQ
X-IronPort-AV: E=Sophos;i="4.51,323,1267398000"; 
   d="scan'208";a="56733210"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wblinux_f.h Coding style fixes.
Date: Sun, 28 Mar 2010 21:56:58 +0200
Message-Id: <1269806218-15716-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed whitespace and comments.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wblinux_f.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index 868e877..50d158b 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -4,13 +4,12 @@
 #include "core.h"
 #include "mds_s.h"
 
-//=========================================================================
-// Copyright (c) 1996-2004 Winbond Electronic Corporation
-//
-// wblinux_f.h
-//
-int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev );
-void wb35_set_multicast( struct net_device *netdev );
-struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
-
+/* ====================================================================
+ * Copyright (c) 1996-2004 Winbond Electronic Corporation
+ *
+ * wblinux_f.h
+ */
+int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev);
+void wb35_set_multicast(struct net_device *netdev);
+struct net_device_stats *wb35_netdev_stats(struct net_device *netdev);
 #endif
-- 
1.7.0.3

