Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1CGJMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:12:22 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:50057 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab1CGJMU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:12:20 -0500
From: Daniel WILLERUD <daniel.willerud@stericsson.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Mar 2011 10:11:39 +0100
Subject: RE: [PATCH 1/5] mfd: move ab8500 gpadc header to subdir
Thread-Topic: [PATCH 1/5] mfd: move ab8500 gpadc header to subdir
Thread-Index: AcvbIohYL0jziRPMSJuI90vhlTPtxQBhOO/g
Message-ID: <757395B8DE5A844B80F3F4BE9867DDB64FAF4FA2A1@EXDCVYMBSTM006.EQ1STM.local>
References: <1299321961-6765-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1299321961-6765-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Daniel Willerud <daniel.willerud@stericsson.com>

-----Original Message-----
From: Linus WALLEIJ 
Sent: den 5 mars 2011 11:46
To: Samuel Ortiz; linux-kernel@vger.kernel.org
Cc: Lee Jones; Daniel WILLERUD; Linus Walleij
Subject: [PATCH 1/5] mfd: move ab8500 gpadc header to subdir

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

