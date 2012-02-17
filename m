Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2BQGlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:41:51 -0500
Received: from mail2.nsc.com ([12.238.8.132]:60112 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751491Ab2BQGlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:41:50 -0500
X-WSS-ID: 0LZIYLL-0A-2HE-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 22:41:32 -0800
Subject: [PATCH 1/3] regulator: fix wrong header name in description
Thread-Topic: [PATCH 1/3] regulator: fix wrong header name in
 description
Thread-Index: AcztPy+l6sfD5EkmQvahLvuY7ENoKA==
Message-ID: <B567DBAB974C0544994013492B949F8E381301284C@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6323292A1LS10440584-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'mode' is defined in consumer.h.

* patch base version : linux-3.2.4

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/regulator/driver.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 52c89ae..df6e9ec 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -104,7 +104,7 @@ struct regulator_ops {
 	int (*disable) (struct regulator_dev *);
 	int (*is_enabled) (struct regulator_dev *);
 
-	/* get/set regulator operating mode (defined in regulator.h) */
+	/* get/set regulator operating mode (defined in consumer.h) */
 	int (*set_mode) (struct regulator_dev *, unsigned int mode);
 	unsigned int (*get_mode) (struct regulator_dev *);
 
@@ -135,7 +135,7 @@ struct regulator_ops {
 	int (*set_suspend_enable) (struct regulator_dev *);
 	int (*set_suspend_disable) (struct regulator_dev *);
 
-	/* set regulator suspend operating mode (defined in regulator.h) */
+	/* set regulator suspend operating mode (defined in consumer.h) */
 	int (*set_suspend_mode) (struct regulator_dev *, unsigned int mode);
 };
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated



