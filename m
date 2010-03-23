Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0CWStN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:49:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:42621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753198Ab0CWStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:49:11 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX1/SStxCFXbSsmN4Nn/bWzs76w3DIcSHqb/QiN7iQl
	dHdpRT7zC9oDTa
From: swirl@gmx.li
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <swirl@gmx.li>,
       Thomas Weber <weber@corscience.de>
Subject: [PATCHv2] linux: i2c: twl.h: Fix typo and tab
Date: Tue, 23 Mar 2010 19:50:16 +0100
Message-Id: <1269370216-30111-1-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.7.0.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Weber <swirl@gmx.li>

Fix typo in comments:
	- contollable => controllable
	- uniqe => unique

Replace tab with whitespace in defines.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 include/linux/i2c/twl.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index fb6784e..a63b77d 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -496,7 +496,7 @@ struct twl4030_madc_platform_data {
 	int		irq_line;
 };
 
-/* Boards have uniqe mappings of {row, col} --> keycode.
+/* Boards have unique mappings of {row, col} --> keycode.
  * Column and row are 8 bits each, but range only from 0..7.
  * a PERSISTENT_KEY is "always on" and never reported.
  */
@@ -664,15 +664,15 @@ static inline int twl4030charger_usb_en(int enable) { return 0; }
 #define TWL4030_REG_VUSB3V1	19
 
 /* TWL6030 SMPS/LDO's */
-/* EXTERNAL dc-to-dc buck convertor contollable via SR */
+/* EXTERNAL dc-to-dc buck convertor controllable via SR */
 #define TWL6030_REG_VDD1	30
 #define TWL6030_REG_VDD2	31
 #define TWL6030_REG_VDD3	32
 
 /* Non SR compliant dc-to-dc buck convertors */
-#define	TWL6030_REG_VMEM	33
+#define TWL6030_REG_VMEM	33
 #define TWL6030_REG_V2V1	34
-#define	TWL6030_REG_V1V29	35
+#define TWL6030_REG_V1V29	35
 #define TWL6030_REG_V1V8	36
 
 /* EXTERNAL LDOs */
-- 
1.7.0.2

