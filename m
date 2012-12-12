Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2LLOER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:04:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50937 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2LLODS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:03:18 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/33] leds-lp5521/5523: add author and copyright description
Thread-Topic: [PATCH 31/33] leds-lp5521/5523: add author and copyright
 description
Thread-Index: Ac3YcW0L7NMS6Y4PTPWvdVjJ6VGBuQ==
Date: Wed, 12 Dec 2012 14:03:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AC0F@DQHE02.ent.ti.com>
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

 Now LP5521 and LP5523 drivers are based on new lp55xx structure.
 So the author and copyrights are updated.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    3 +++
 drivers/leds/leds-lp5523.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 9de5aec..4709e83 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -2,8 +2,10 @@
  * LP5521 LED chip driver.
  *
  * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments
  *
  * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *          Milo(Woogyom) Kim <milo.kim@ti.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -481,5 +483,6 @@ static struct i2c_driver lp5521_driver = {
 module_i2c_driver(lp5521_driver);
 
 MODULE_AUTHOR("Mathias Nyman, Yuri Zaporozhets, Samu Onkalo");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
 MODULE_DESCRIPTION("LP5521 LED engine");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 359d6c7..5dcafbd 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -2,8 +2,10 @@
  * lp5523.c - LP5523 LED Driver
  *
  * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments
  *
  * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *          Milo(Woogyom) Kim <milo.kim@ti.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -510,5 +512,6 @@ static struct i2c_driver lp5523_driver = {
 module_i2c_driver(lp5523_driver);
 
 MODULE_AUTHOR("Mathias Nyman <mathias.nyman@nokia.com>");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
 MODULE_DESCRIPTION("LP5523 LED engine");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5


Best Regards,
Milo


