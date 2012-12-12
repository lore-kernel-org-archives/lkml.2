Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2LLODP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:03:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42357 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab2LLODF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:03:05 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/33] leds-lp55xx: clean up headers
Thread-Topic: [PATCH 28/33] leds-lp55xx: clean up headers
Thread-Index: Ac3YcWUnec4sC2SvQL+5ke5TRgfibQ==
Date: Wed, 12 Dec 2012 14:03:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABF7@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove unused headers and sort them alphabetically

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   19 ++++++-------------
 drivers/leds/leds-lp5523.c |   19 ++++++-------------
 2 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index af55eb3..23d0bee 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -20,22 +20,15 @@
  * 02110-1301 USA
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/mutex.h>
-#include <linux/gpio.h>
-#include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/ctype.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/leds.h>
-#include <linux/leds-lp5521.h>
-#include <linux/workqueue.h>
-#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/leds-lp55xx.h>
-#include <linux/firmware.h>
+#include <linux/slab.h>
 
 #include "leds-lp55xx-common.h"
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 60d39b8..359d6c7 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -20,22 +20,15 @@
  * 02110-1301 USA
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/mutex.h>
-#include <linux/gpio.h>
-#include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/ctype.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/leds.h>
-#include <linux/leds-lp5523.h>
-#include <linux/workqueue.h>
-#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/leds-lp55xx.h>
-#include <linux/firmware.h>
+#include <linux/slab.h>
 
 #include "leds-lp55xx-common.h"
 
-- 
1.7.9.5


Best Regards,
Milo


