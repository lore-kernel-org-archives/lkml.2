Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948Ab0EZXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995Ab0EZXkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:46 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 02/15] Staging: winbond: Replace C99 comments with C88
Date: Thu, 27 May 2010 00:39:39 +0100
Message-Id: <1274917192-16962-2-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches mac_structures.h to replace all the C99 style comments (//) with C89 style (/* ... */), as reported by checkpatch.pl.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/mac_structures.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 84ab290..42dc7a8 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -98,28 +98,28 @@
 #define ELEMENT_ID_CF_PARAMETER_SET         4
 #define ELEMENT_ID_TIM                      5
 #define ELEMENT_ID_IBSS_PARAMETER_SET       6
-// 7~15 reserverd
+/* 7~15 reserverd */
 #define ELEMENT_ID_CHALLENGE_TEXT           16
-// 17~31 reserved for challenge text extension
-// 32~255 reserved
-//--  11G  --
+/* 17~31 reserved for challenge text extension */
+/* 32~255 reserved */
+/*--  11G  --*/
 #define ELEMENT_ID_ERP_INFORMATION			42
 #define ELEMENT_ID_EXTENDED_SUPPORTED_RATES 50
 
-//--  WPA  --
+/*--  WPA  --*/
 
 #define ELEMENT_ID_RSN_WPA					221
 #ifdef _WPA2_
 #define ELEMENT_ID_RSN_WPA2				    48
-#endif //endif WPA2
+#endif /*endif WPA2*/
 
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
 
-//===================================================================
+/*===================================================================
 //  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
 //  length of ReasonCode is 2 Octs.
-//===================================================================
+//===================================================================*/
 #define REASON_REASERED             0
 #define REASON_UNSPECIDIED          1
 #define REASON_PREAUTH_INVALID      2
@@ -430,7 +430,7 @@ struct suite_selector {
 	};
 };
 
-//--  WPA  --
+/*--  WPA  --*/
 struct	RSN_Information_Element {
 	u8					Element_ID;
 	u8					Length;
-- 
1.7.0.4

