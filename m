Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2A0G6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:58:40 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33749 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301Ab2A0G6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:58:39 -0500
X-WSS-ID: 0LYG3DM-0A-25I-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:58:15 -0800
Subject: [PATCH 1/6] lp8727_charger: change description about company
Thread-Topic: [PATCH 1/6] lp8727_charger: change description about
 company
Thread-Index: AczcwQrHt3zlqZutQbWeqNcnqKuJjg==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB06@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94801LS9965369-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI acquired National semiconductor at 2011.
: National semiconductor -> Texas Instruments

Add driver information in the header file.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    4 ++--
 include/linux/lp8727.h         |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..97be22e 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -1,7 +1,7 @@
 /*
  * Driver for LP8727 Micro/Mini USB IC with intergrated charger
  *
- *			Copyright (C) 2011 National Semiconductor
+ *			Copyright (C) 2011 Texas Instruments
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -488,7 +488,7 @@ static void __exit lp8727_exit(void)
 module_init(lp8727_init);
 module_exit(lp8727_exit);
 
-MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
+MODULE_DESCRIPTION("Texas Instruments LP8727 charger driver");
 MODULE_AUTHOR
     ("Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
index d21fa28..43d4242 100644
--- a/include/linux/lp8727.h
+++ b/include/linux/lp8727.h
@@ -1,5 +1,7 @@
 /*
- *			Copyright (C) 2011 National Semiconductor
+ * LP8727 Micro/Mini USB IC with intergrated charger
+ *
+ *			Copyright (C) 2011 Texas Instruments
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




