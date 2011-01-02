Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1ABOMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:12:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ABOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:12:52 -0500
From: Stefan Weil <weil@mail.berlios.de>
Cc: Stefan Weil <weil@mail.berlios.de>, Kalle Valo <kvalo@adurom.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling meassge -> message in comments
Date: Sun,  2 Jan 2011 15:12:42 +0100
Message-Id: <1293977562-4700-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:IuyGdew/yBFcFua62kzayYLkivGCSHdBnbLSizTo6nY
 M0izsSZOeAilUzhEI+axGswahHg7e5UM4rPes7xJhqKOfcngbt
 1C3NQYroXPkhxxsUcln4LER+jr9QYDWGTaK4ATSmzRv38PsF+H
 LZW9591v1COGLIO0kB79zPBQYuFSlXPo/37XxrYVX5fxjb1SBT
 3PAOrRFqEJdbVUigLVwjJ/cawLkPdIY5XjJr6IC/Ee/htl+JdC
 VGH35li2Mv+p5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Kalle Valo <kvalo@adurom.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/net/wireless/wl1251/acx.h        |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_acx.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index e54b21a..efcc3aa 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -1272,10 +1272,10 @@ struct wl1251_acx_tid_cfg {
 /* OBSOLETE */
 #define WL1251_ACX_INTR_WAKE_ON_HOST	BIT(6)
 
-/* Trace meassge on MBOX #A */
+/* Trace message on MBOX #A */
 #define WL1251_ACX_INTR_TRACE_A		BIT(7)
 
-/* Trace meassge on MBOX #B */
+/* Trace message on MBOX #B */
 #define WL1251_ACX_INTR_TRACE_B		BIT(8)
 
 /* Command processing completion */
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index ebb341d..0ce845f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -47,9 +47,9 @@
 #define WL1271_ACX_INTR_HW_AVAILABLE       BIT(5)
 /* The MISC bit is used for aggregation of RX, TxComplete and TX rate update */
 #define WL1271_ACX_INTR_DATA               BIT(6)
-/* Trace meassge on MBOX #A */
+/* Trace message on MBOX #A */
 #define WL1271_ACX_INTR_TRACE_A            BIT(7)
-/* Trace meassge on MBOX #B */
+/* Trace message on MBOX #B */
 #define WL1271_ACX_INTR_TRACE_B            BIT(8)
 
 #define WL1271_ACX_INTR_ALL		   0xFFFFFFFF
-- 
1.7.2.3

