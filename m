Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2JEIYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:24:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56201 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab2JEIYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:24:16 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/28] leds-lp5521/5523: clean up headers
Thread-Topic: [PATCH 24/28] leds-lp5521/5523: clean up headers
Thread-Index: Ac2i0smb1+6Z2N9hR+yfnJJ/Np2n7Q==
Date: Fri, 5 Oct 2012 08:24:07 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176849@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 Remove unused headers and sort them alphabetically.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   17 +++++------------
 drivers/leds/leds-lp5523.c |   17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 8b29d6b..725eace 100644
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
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/leds-lp55xx.h>
-#include <linux/workqueue.h>
 #include <linux/slab.h>
-#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index bad85a9..d620619 100644
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
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/leds-lp55xx.h>
-#include <linux/workqueue.h>
 #include <linux/slab.h>
-#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
-- 
1.7.9.5


Best Regards,
Milo


