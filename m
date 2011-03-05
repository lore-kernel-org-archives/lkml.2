Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1CEKtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:49:01 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:56473 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab1CEKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:48:59 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/5] mfd: move ab8500 gpadc header to subdir
Date: Sat, 5 Mar 2011 11:46:01 +0100
Message-ID: <1299321961-6765-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Willerud <daniel.willerud@stericsson.com>

This moves the ab8500-gpadc.h header down into the ab8500/
subdir in include/linux/mfd and fixes some whitespace in the
header in the process.

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c              |    2 +-
 include/linux/mfd/ab8500-gpadc.h        |   28 ----------------------------
 include/linux/mfd/ab8500/ab8500-gpadc.h |   28 ++++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 29 deletions(-)
 delete mode 100644 include/linux/mfd/ab8500-gpadc.h
 create mode 100644 include/linux/mfd/ab8500/ab8500-gpadc.h

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 19339bc..f60f71f4 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500-gpadc.h>
+#include <linux/mfd/ab8500/ab8500-gpadc.h>
 
 /*
  * GPADC register offsets
diff --git a/include/linux/mfd/ab8500-gpadc.h b/include/linux/mfd/ab8500-gpadc.h
deleted file mode 100644
index 9f6cc26..0000000
--- a/include/linux/mfd/ab8500-gpadc.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) 2010 ST-Ericsson SA
- * Licensed under GPLv2.
- *
- * Author: Arun R Murthy <arun.murthy@stericsson.com>
- */
-
-#ifndef	_AB8500_GPADC_H
-#define _AB8500_GPADC_H
-
-/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
-#define BAT_CTRL        0x01
-#define BTEMP_BALL      0x02
-#define MAIN_CHARGER_V  0x03
-#define ACC_DETECT1     0x04
-#define ACC_DETECT2     0x05
-#define ADC_AUX1	0x06
-#define ADC_AUX2	0x07
-#define MAIN_BAT_V      0x08
-#define VBUS_V          0x09
-#define MAIN_CHARGER_C  0x0A
-#define USB_CHARGER_C   0x0B
-#define BK_BAT_V        0x0C
-#define DIE_TEMP        0x0D
-
-int ab8500_gpadc_convert(u8 input);
-
-#endif /* _AB8500_GPADC_H */
diff --git a/include/linux/mfd/ab8500/ab8500-gpadc.h b/include/linux/mfd/ab8500/ab8500-gpadc.h
new file mode 100644
index 0000000..74b87dd
--- /dev/null
+++ b/include/linux/mfd/ab8500/ab8500-gpadc.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2010 ST-Ericsson SA
+ * Licensed under GPLv2.
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ */
+
+#ifndef	_AB8500_GPADC_H
+#define _AB8500_GPADC_H
+
+/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
+#define BAT_CTRL	0x01
+#define BTEMP_BALL	0x02
+#define MAIN_CHARGER_V	0x03
+#define ACC_DETECT1	0x04
+#define ACC_DETECT2	0x05
+#define ADC_AUX1	0x06
+#define ADC_AUX2	0x07
+#define MAIN_BAT_V	0x08
+#define VBUS_V		0x09
+#define MAIN_CHARGER_C	0x0A
+#define USB_CHARGER_C	0x0B
+#define BK_BAT_V	0x0C
+#define DIE_TEMP	0x0D
+
+int ab8500_gpadc_convert(u8 input);
+
+#endif /* _AB8500_GPADC_H */
-- 
1.7.3.2

