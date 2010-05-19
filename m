Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0ESFzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:55:36 -0400
Received: from penguin.host-ns.co.uk ([213.229.84.196]:55610 "EHLO
	penguin.host-ns.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0ESFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:55:34 -0400
Subject: [PATCH] Staging: winbond: Fix C99 Comment issues in
 mac_structures.h
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Reply-To: adam.latham@unisontorbay.org.uk
To: gregkh@suse.de, sankar.curiosity@gmail.com, ruslan@rpisarev.org.ua,
       adam.latham@unisontorbay.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 06:55:26 +0100
Message-ID: <1274248526.2667.2.camel@ubuntu.ubuntu-domain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - penguin.host-ns.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - unisontorbay.org.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 75719374c007bfb664b866df3e7c1f30c93354d4 Mon Sep 17 00:00:00 2001
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Date: Tue, 18 May 2010 20:00:00 +0100
Subject: [PATCH] Staging: winbond: Fix C99 Comment issues in mac_structures.h

This patch fixes the use of //C99 comments in the mac_structures.h found by
the checkpatch.pl tool

Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
---
 drivers/staging/winbond/mac_structures.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 7441015..a390adf 100644
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
+/*--  11G  -- */
 #define ELEMENT_ID_ERP_INFORMATION			42
 #define ELEMENT_ID_EXTENDED_SUPPORTED_RATES 50
 
-//--  WPA  --
+/* --  WPA  -- */
 
 #define ELEMENT_ID_RSN_WPA					221
 #ifdef _WPA2_
 #define ELEMENT_ID_RSN_WPA2				    48
-#endif //endif WPA2
+#endif /* endif WPA2 */
 
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
 
-//===================================================================
-//  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
-//  length of ReasonCode is 2 Octs.
-//===================================================================
+/* ===================================================================
+*  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
+*  length of ReasonCode is 2 Octs.
+* =================================================================== */
 #define REASON_REASERED             0
 #define REASON_UNSPECIDIED          1
 #define REASON_PREAUTH_INVALID      2
@@ -433,7 +433,7 @@ struct suite_selector
 	};
 };
 
-//--  WPA  --
+/* --  WPA  -- */
 struct	RSN_Information_Element
 {
 	u8					Element_ID;
-- 
1.7.0.4



