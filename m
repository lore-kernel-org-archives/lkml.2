Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2A0G7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:59:20 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33809 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572Ab2A0G7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:59:13 -0500
X-WSS-ID: 0LYG3EL-0A-25Q-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:58:51 -0800
Subject: [PATCH 4/6] lp8727_charger: fix wrong code style
Thread-Topic: [PATCH 4/6] lp8727_charger: fix wrong code style
Thread-Index: AczcwSADCwq1WrT/RUK0a7pLveuG+w==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB09@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94A71LS9965378-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Definition of STATUS2
: remove space before tabs.

Return code of lp8727_is_dedicated_charger(), lp8727_is_usb_charger()
: remove parentheses when return is not a function.

MODULE_AUTHOR section
: remove space at the start of a line.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b333cdd..b531725 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -25,7 +25,7 @@
 #define INT1		0x4
 #define INT2		0x5
 #define STATUS1		0x6
-#define STATUS2 	0x7
+#define STATUS2		0x7
 #define CHGCTRL2	0x9
 
 /* CTRL1 register */
@@ -152,14 +152,14 @@ static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
 	lp8727_read_byte(pchg, STATUS1, &val);
-	return (val & DCPORT);
+	return val & DCPORT;
 }
 
 static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
 	lp8727_read_byte(pchg, STATUS1, &val);
-	return (val & CHPORT);
+	return val & CHPORT;
 }
 
 static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
@@ -503,5 +503,5 @@ module_exit(lp8727_exit);
 
 MODULE_DESCRIPTION("Texas Instruments LP8727 charger driver");
 MODULE_AUTHOR
-    ("Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
+("Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




