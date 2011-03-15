Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1CON07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:26:59 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:46024 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757784Ab1CON06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:26:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: rename ab8500 gpadc header
Date: Tue, 15 Mar 2011 14:26:37 +0100
Message-ID: <1300195597-7446-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Rename AB8500 GPADC header so as not to be redunantly named.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c              |    2 +-
 include/linux/mfd/ab8500/ab8500-gpadc.h |   32 -------------------------------
 include/linux/mfd/ab8500/gpadc.h        |   32 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 33 deletions(-)
 delete mode 100644 include/linux/mfd/ab8500/ab8500-gpadc.h
 create mode 100644 include/linux/mfd/ab8500/gpadc.h

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 2ad3115..bc93b2e 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -20,7 +20,7 @@
 #include <linux/list.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500/ab8500-gpadc.h>
+#include <linux/mfd/ab8500/gpadc.h>
 
 /*
  * GPADC register offsets
diff --git a/include/linux/mfd/ab8500/ab8500-gpadc.h b/include/linux/mfd/ab8500/ab8500-gpadc.h
deleted file mode 100644
index 46b9540..0000000
--- a/include/linux/mfd/ab8500/ab8500-gpadc.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (C) 2010 ST-Ericsson SA
- * Licensed under GPLv2.
- *
- * Author: Arun R Murthy <arun.murthy@stericsson.com>
- * Author: Daniel Willerud <daniel.willerud@stericsson.com>
- */
-
-#ifndef	_AB8500_GPADC_H
-#define _AB8500_GPADC_H
-
-/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
-#define BAT_CTRL	0x01
-#define BTEMP_BALL	0x02
-#define MAIN_CHARGER_V	0x03
-#define ACC_DETECT1	0x04
-#define ACC_DETECT2	0x05
-#define ADC_AUX1	0x06
-#define ADC_AUX2	0x07
-#define MAIN_BAT_V	0x08
-#define VBUS_V		0x09
-#define MAIN_CHARGER_C	0x0A
-#define USB_CHARGER_C	0x0B
-#define BK_BAT_V	0x0C
-#define DIE_TEMP	0x0D
-
-struct ab8500_gpadc;
-
-struct ab8500_gpadc *ab8500_gpadc_get(char *name);
-int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input);
-
-#endif /* _AB8500_GPADC_H */
diff --git a/include/linux/mfd/ab8500/gpadc.h b/include/linux/mfd/ab8500/gpadc.h
new file mode 100644
index 0000000..46b9540
--- /dev/null
+++ b/include/linux/mfd/ab8500/gpadc.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2010 ST-Ericsson SA
+ * Licensed under GPLv2.
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * Author: Daniel Willerud <daniel.willerud@stericsson.com>
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
+struct ab8500_gpadc;
+
+struct ab8500_gpadc *ab8500_gpadc_get(char *name);
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input);
+
+#endif /* _AB8500_GPADC_H */
-- 
1.7.3.2

