Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2JNMfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 08:35:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34728 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2JNMfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 08:35:47 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] Drivers: Staging: CSR: fixed coding style errors
Date: Sun, 14 Oct 2012 21:35:32 +0900
Message-Id: <1350218132-20434-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally there were a lot of coding style errors so, I cleaned up the
coding style errors including braces and indentations.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 .../csr/csr_wifi_router_free_upstream_contents.c   |   46 +++++++++-----------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_router_free_upstream_contents.c b/drivers/staging/csr/csr_wifi_router_free_upstream_contents.c
index de1086d..352a41b 100644
--- a/drivers/staging/csr/csr_wifi_router_free_upstream_contents.c
+++ b/drivers/staging/csr/csr_wifi_router_free_upstream_contents.c
@@ -1,10 +1,10 @@
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2011
-            All rights reserved and confidential information of CSR
+(c) Cambridge Silicon Radio Limited 2011
+All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+Refer to LICENSE.txt included with this source for details
+on the license terms.
 
 *****************************************************************************/
 
@@ -26,28 +26,22 @@
  *----------------------------------------------------------------------------*/
 void CsrWifiRouterFreeUpstreamMessageContents(u16 eventClass, void *message)
 {
-    if (eventClass != CSR_WIFI_ROUTER_PRIM)
-    {
-        return;
-    }
-    if (NULL == message)
-    {
-        return;
-    }
-
-    switch (*((CsrWifiRouterPrim *) message))
-    {
-        case CSR_WIFI_ROUTER_MA_PACKET_IND:
-        {
-            CsrWifiRouterMaPacketInd *p = (CsrWifiRouterMaPacketInd *)message;
-            kfree(p->frame);
-            p->frame = NULL;
-            break;
-        }
-
-        default:
-            break;
-    }
+	if (eventClass != CSR_WIFI_ROUTER_PRIM)
+		return;
+	if (NULL == message)
+		return;
+	switch (*((CsrWifiRouterPrim *) message)) {
+	case CSR_WIFI_ROUTER_MA_PACKET_IND:
+	{
+		CsrWifiRouterMaPacketInd *p =
+			(CsrWifiRouterMaPacketInd *) message;
+		kfree(p->frame);
+		p->frame = NULL;
+		break;
+	}
+	default:
+		break;
+	}
 }
 
 
-- 
1.7.9.5

