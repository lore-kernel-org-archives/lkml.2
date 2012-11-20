Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2KTOpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36327 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2KTOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:37 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 6/8] staging: wlags49_h2: wl_if.h: gets rid of C99 // comments
Date: Tue, 20 Nov 2012 16:44:58 +0200
Message-Id: <1353422700-14485-5-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts all C99 // comments to standard /* */ comments

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |   39 +++++++++++++++---------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index 351d29b..425d373 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -80,24 +80,17 @@
 #define TX_TIMEOUT                  ((800 * HZ) / 1000)
 
 
-//#define HCF_MIN_COMM_QUALITY        0
-//#define HCF_MAX_COMM_QUALITY        92
-//#define HCF_MIN_SIGNAL_LEVEL        47
-//#define HCF_MAX_SIGNAL_LEVEL        138
-//#define HCF_MIN_NOISE_LEVEL         47
-//#define HCF_MAX_NOISE_LEVEL         138
-//#define HCF_0DBM_OFFSET             149
-
-// PE1DNN
-// Better data from the real world. Not scientific but empirical data gathered
-// from a Thomson Speedtouch 110 which is identified as:
-// PCMCIA Info: "Agere Systems" "Wireless PC Card Model 0110"
-//              Manufacture ID: 0156,0003
-// Lowest measurment for noise floor seen is value 54
-// Highest signal strength in close proximity to the AP seen is value 118
-// Very good must be around 100 (otherwise its never "full scale"
-// All other constants are derrived from these. This makes the signal gauge
-// work for me...
+/* PE1DNN
+ * Better data from the real world. Not scientific but empirical data gathered
+ * from a Thomson Speedtouch 110 which is identified as:
+ * PCMCIA Info: "Agere Systems" "Wireless PC Card Model 0110"
+ *              Manufacture ID: 0156,0003
+ * Lowest measurment for noise floor seen is value 54
+ * Highest signal strength in close proximity to the AP seen is value 118
+ * Very good must be around 100 (otherwise its never "full scale"
+ * All other constants are derrived from these. This makes the signal gauge
+ * work for me...
+ */
 #define HCF_MIN_SIGNAL_LEVEL        54
 #define HCF_MAX_SIGNAL_LEVEL        100
 #define HCF_MIN_NOISE_LEVEL         HCF_MIN_SIGNAL_LEVEL
@@ -109,8 +102,8 @@
 
 
 /* For encryption (WEP) */
-#define MIN_KEY_SIZE                5       // 40 bits RC4 - WEP
-#define MAX_KEY_SIZE                13      // 104 bits
+#define MIN_KEY_SIZE                5       /* 40 bits RC4 - WEP */
+#define MAX_KEY_SIZE                13      /* 104 bits */
 #define MAX_KEYS                    4
 
 #define RADIO_CHANNELS              14
@@ -126,8 +119,8 @@
 
 #define HCF_FAILURE                 0xFF
 #define UIL_FAILURE		            0xFF
-#define CFG_UIL_CONNECT             0xA123          // Define differently?
-#define CFG_UIL_CONNECT_ACK_CODE    0x5653435A      // VSCZ
+#define CFG_UIL_CONNECT             0xA123          /* Define differently? */
+#define CFG_UIL_CONNECT_ACK_CODE    0x5653435A      /* VSCZ */
 #define WVLAN2_UIL_CONNECTED        (0x01L << 0)
 #define WVLAN2_UIL_BUSY             (0x01L << 1)
 
@@ -224,5 +217,5 @@ struct rtsreq {
 };
 
 
-#endif  // __WAVELAN2_IF_H__
+#endif  /* __WAVELAN2_IF_H__ */
 
-- 
1.7.10.4

