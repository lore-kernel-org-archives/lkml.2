Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2JEIZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:25:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2JEIZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:25:32 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/28] leds-lp5521/5523: add author and copyright description
Thread-Topic: [PATCH 26/28] leds-lp5521/5523: add author and copyright
 description
Thread-Index: Ac2i0vPF5lt20Z5KSQu3c4dRg/4I5Q==
Date: Fri, 5 Oct 2012 08:25:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417686D@DQHE02.ent.ti.com>
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

 Add the author and copyright about the new lp55xx structure.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    3 +++
 drivers/leds/leds-lp5523.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 725eace..181d73f 100644
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
@@ -474,5 +476,6 @@ static struct i2c_driver lp5521_driver = {
 module_i2c_driver(lp5521_driver);
 
 MODULE_AUTHOR("Mathias Nyman, Yuri Zaporozhets, Samu Onkalo");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
 MODULE_DESCRIPTION("LP5521 LED engine");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index d620619..66d57a5 100644
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
@@ -503,5 +505,6 @@ static struct i2c_driver lp5523_driver = {
 module_i2c_driver(lp5523_driver);
 
 MODULE_AUTHOR("Mathias Nyman <mathias.nyman@nokia.com>");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
 MODULE_DESCRIPTION("LP5523 LED engine");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5


Best Regards,
Milo

