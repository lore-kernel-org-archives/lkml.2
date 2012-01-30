Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2A3B2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:28:33 -0500
Received: from mail2.nsc.com ([12.238.8.132]:46223 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752286Ab2A3B2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:28:32 -0500
X-WSS-ID: 0LYL83F-0A-0NB-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jan 2012 17:28:18 -0800
Subject: [PATCH v2] lp8727_charger: add company name and description
Thread-Topic: [PATCH v2] lp8727_charger: add company name and
 description
Thread-Index: Acze7nHlB7IuDKMKSdyZw6VLQIQ2ow==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EFBF@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633B2DBC1LS10007916-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'Texas Instruments' because TI acquired National semiconductor at 2011.
And the driver information is added in the header file.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/Kconfig          |    2 +-
 drivers/power/lp8727_charger.c |    3 ++-
 include/linux/lp8727.h         |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 3a8daf8..97680d8 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -235,7 +235,7 @@ config CHARGER_TWL4030
 	  Say Y here to enable support for TWL4030 Battery Charge Interface.
 
 config CHARGER_LP8727
-	tristate "National Semiconductor LP8727 charger driver"
+	tristate "TI/National Semiconductor LP8727 charger driver"
 	depends on I2C
 	help
 	  Say Y here to enable support for LP8727 Charger Driver.
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..e603483 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -1,6 +1,7 @@
 /*
  * Driver for LP8727 Micro/Mini USB IC with intergrated charger
  *
+ *			Copyright (C) 2011 Texas Instruments
  *			Copyright (C) 2011 National Semiconductor
  *
  * This program is free software; you can redistribute it and/or modify
@@ -488,7 +489,7 @@ static void __exit lp8727_exit(void)
 module_init(lp8727_init);
 module_exit(lp8727_exit);
 
-MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
+MODULE_DESCRIPTION("TI/National Semiconductor LP8727 charger driver");
 MODULE_AUTHOR
     ("Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
index d21fa28..95371c4 100644
--- a/include/linux/lp8727.h
+++ b/include/linux/lp8727.h
@@ -1,4 +1,7 @@
 /*
+ * LP8727 Micro/Mini USB IC with intergrated charger
+ *
+ *			Copyright (C) 2011 Texas Instruments
  *			Copyright (C) 2011 National Semiconductor
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

