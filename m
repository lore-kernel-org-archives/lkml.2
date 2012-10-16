Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2JPQtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:49:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34178 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab2JPQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:49:46 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/2] staging: csr: Fixed macro definition style errors on csr_wifi_vif_utils.h
Date: Wed, 17 Oct 2012 01:48:30 +0900
Message-Id: <1350406110-2942-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350406110-2942-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350406110-2942-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed 3 lines of code where there were the coding style errors on
defining the macros.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_vif_utils.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_vif_utils.h b/drivers/staging/csr/csr_wifi_vif_utils.h
index c997398..f1374f2 100644
--- a/drivers/staging/csr/csr_wifi_vif_utils.h
+++ b/drivers/staging/csr/csr_wifi_vif_utils.h
@@ -25,8 +25,8 @@ extern "C" {
 
 /* Common macros for NME and SME to be used temporarily until SoftMAC
  * changes are made */
-#define CSR_WIFI_NUM_INTERFACES		(u8)0x1
-#define CSR_WIFI_INTERFACE_IN_USE	(u16)0x0
+#define CSR_WIFI_NUM_INTERFACES		((u8)0x1)
+#define CSR_WIFI_INTERFACE_IN_USE	((u16)0x0)
 
 /* This is used at places where interface Id isn't available*/
 #define CSR_WIFI_INTERFACE_ZERO		0
@@ -38,7 +38,7 @@ extern "C" {
 
 /* Extract the Interface Id from the event */
 #define CsrWifiVifUtilsGetVifTagFromEvent(msg) \
-	((u16) * ((u16 *) ((u8 *) (msg) + sizeof(CsrWifiFsmEvent))))
+	((u16) *((u16 *) ((u8 *) (msg) + sizeof(CsrWifiFsmEvent))))
 
 /* The HPI Vif combines the type and the interface id */
 #define CsrWifiVifUtilsGetVifTagFromHipEvent(msg) \
-- 
1.7.9.5

