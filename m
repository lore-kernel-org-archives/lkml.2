Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2A0G7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:59:18 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33811 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751917Ab2A0G7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:59:13 -0500
X-WSS-ID: 0LYG3EL-0A-25T-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:59:00 -0800
Subject: [PATCH 5/6] lp8727_charger: add description of platform data
Thread-Topic: [PATCH 5/6] lp8727_charger: add description of platform
 data
Thread-Index: AczcwSWhKIfJWMNqTxSIM8f5g+qnUw==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB0A@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94BC1LS9965383-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add brief description of lp8727_platform_data and lp8727_chg_param.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/lp8727.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
index 43d4242..9a4611f 100644
--- a/include/linux/lp8727.h
+++ b/include/linux/lp8727.h
@@ -34,13 +34,24 @@ enum lp8727_ichg {
 	ICHG_1000mA,
 };
 
+/**
+ * struct lp8727_chg_param
+ * @eoc_level : end of charge level setting
+ * @ichg : charging current
+ */
 struct lp8727_chg_param {
-	/* end of charge level setting */
 	enum lp8727_eoc_level eoc_level;
-	/* charging current */
 	enum lp8727_ichg ichg;
 };
 
+/**
+ * struct lp8727_platform_data
+ * @get_batt_present : check battery status - exists or not
+ * @get_batt_level : get battery voltage (mV)
+ * @get_batt_capacity : get battery capacity (%)
+ * @get_batt_temp : get battery temperature
+ * @ac, @usb : charging parameters each charger type
+ */
 struct lp8727_platform_data {
 	u8 (*get_batt_present)(void);
 	u16 (*get_batt_level)(void);
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




