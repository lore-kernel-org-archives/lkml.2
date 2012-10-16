Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2JPQtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:49:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2JPQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:49:44 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/2] staging: csr: Fixed indentation errors on csr_wifi_vif_utils.h
Date: Wed, 17 Oct 2012 01:48:29 +0900
Message-Id: <1350406110-2942-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were 4 spaces indented lines, so I fixed using tabs.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_vif_utils.h |   58 ++++++++++++++++--------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_vif_utils.h b/drivers/staging/csr/csr_wifi_vif_utils.h
index 523172d..c997398 100644
--- a/drivers/staging/csr/csr_wifi_vif_utils.h
+++ b/drivers/staging/csr/csr_wifi_vif_utils.h
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
 
@@ -23,28 +23,29 @@ extern "C" {
 
 /* MACROS *******************************************************************/
 
-/* Common macros for NME and SME to be used temporarily until SoftMAC changes are made */
-#define CSR_WIFI_NUM_INTERFACES        (u8)0x1
-#define CSR_WIFI_INTERFACE_IN_USE      (u16)0x0
+/* Common macros for NME and SME to be used temporarily until SoftMAC
+ * changes are made */
+#define CSR_WIFI_NUM_INTERFACES		(u8)0x1
+#define CSR_WIFI_INTERFACE_IN_USE	(u16)0x0
 
 /* This is used at places where interface Id isn't available*/
-#define CSR_WIFI_INTERFACE_ZERO        0
-#define CSR_WIFI_INTERFACE_STA         0
-#define CSR_WIFI_INTERFACE_AMP         0
+#define CSR_WIFI_INTERFACE_ZERO		0
+#define CSR_WIFI_INTERFACE_STA		0
+#define CSR_WIFI_INTERFACE_AMP		0
 
 
 #define CSR_WIFI_VIF_UTILS_UNDEFINED_TAG 0xFFFF
 
 /* Extract the Interface Id from the event */
 #define CsrWifiVifUtilsGetVifTagFromEvent(msg) \
-    ((u16) * ((u16 *) ((u8 *) (msg) + sizeof(CsrWifiFsmEvent))))
+	((u16) * ((u16 *) ((u8 *) (msg) + sizeof(CsrWifiFsmEvent))))
 
 /* The HPI Vif combines the type and the interface id */
 #define CsrWifiVifUtilsGetVifTagFromHipEvent(msg) \
-    ((msg)->virtualInterfaceIdentifier & 0x00FF)
+	((msg)->virtualInterfaceIdentifier & 0x00FF)
 
 #define CsrWifiVifUtilsPackHipEventVif(type, interfaceId) \
-    ((u16)((interfaceId) | ((type) << 8)))
+	((u16)((interfaceId) | ((type) << 8)))
 
 
 /* TYPES DEFINITIONS ********************************************************/
@@ -55,8 +56,10 @@ extern "C" {
 
 /**
  * @brief
- *     First checks if the mode is supported capability bitmap of the interface.
- *     If this succeeds, then checks if running this mode on this interface is allowed.
+ *	First checks if the mode is supported capability bitmap
+ *	of the interface.
+ *	If this succeeds, then checks if running this mode on this
+ *	interface is allowed.
  *
  * @param[in] u8 : interface capability bitmap
  * @param[in] u8* : pointer to the array of current interface modes
@@ -64,36 +67,37 @@ extern "C" {
  * @param[in] CsrWifiInterfaceMode : mode
  *
  * @return
- *     u8 : returns true if the interface is allowed to operate in the mode otherwise false.
+ *	u8 : returns true if the interface is allowed to operate
+ *	in the mode otherwise false.
  */
-extern u8 CsrWifiVifUtilsCheckCompatibility(u8             interfaceCapability,
-                                                 u8            *currentInterfaceModes,
-                                                 u16            interfaceTag,
-                                                 CsrWifiInterfaceMode mode);
+extern u8 CsrWifiVifUtilsCheckCompatibility(u8 interfaceCapability,
+	u8 *currentInterfaceModes, u16 interfaceTag,
+	CsrWifiInterfaceMode mode);
 
 /**
  * @brief
- *     Checks if the specified interface is supported.
- *     NOTE: Only checks that the interface is supported, no checks are made to
- *     determine whether a supported interface may be made active.
+ *	Checks if the specified interface is supported.
+ *	NOTE: Only checks that the interface is supported,
+ *	no checks are made to determine whether a supported
+ *	interface may be made active.
  *
  * @param[in] u16 : interfaceTag
  *
  * @return
- *     u8 : returns true if the interface is supported, otherwise false.
+ *	u8 : returns true if the interface is supported, otherwise false.
  */
 extern u8 CsrWifiVifUtilsIsSupported(u16 interfaceTag);
 
 #ifdef CSR_LOG_ENABLE
 /**
  * @brief
- *     Registers the virtual interface utils logging details.
- *     Should only be called once at initialisation.
+ *	Registers the virtual interface utils logging details.
+ *	Should only be called once at initialisation.
  *
  * @param[in/out] None
  *
  * @return
- *     None
+ *	None
  */
 void CsrWifiVifUtilsLogTextRegister(void);
 #else
-- 
1.7.9.5

