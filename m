Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0CWKyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:54:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0CWKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:54:03 -0400
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] Fix typos and replace tab with whitespace
Date: Tue, 23 Mar 2010 11:53:49 +0100
Message-Id: <1269341629-26179-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.0.2
X-Provags-ID: V01U2FsdGVkX1+2f71o292AY+gL1SXFvwB+B8Id70e+tu8ME9j
 SqycjscFJ6gx7Wxmh4FPP+tuwl9aDKrvRsZsRPXe1U9h2EKn2x
 1i+K7DV9ymJJPXrymns5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typos:
	convertor => converter
	contollable => controllable
	uniqe => unique

Replace tab with whitespace in defines.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 include/linux/i2c/twl.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index fb6784e..0c25751 100644
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
+/* EXTERNAL dc-to-dc buck converter controllable via SR */
 #define TWL6030_REG_VDD1	30
 #define TWL6030_REG_VDD2	31
 #define TWL6030_REG_VDD3	32
 
-/* Non SR compliant dc-to-dc buck convertors */
-#define	TWL6030_REG_VMEM	33
+/* Non SR compliant dc-to-dc buck converters */
+#define TWL6030_REG_VMEM	33
 #define TWL6030_REG_V2V1	34
-#define	TWL6030_REG_V1V29	35
+#define TWL6030_REG_V1V29	35
 #define TWL6030_REG_V1V8	36
 
 /* EXTERNAL LDOs */
-- 
1.7.0.2

