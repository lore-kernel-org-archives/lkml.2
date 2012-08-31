Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2HaJ1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:27:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45303 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2HaJ12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:27:28 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/22] lp8727_charger: make cosmetic code
Thread-Topic: [PATCH 22/22] lp8727_charger: make cosmetic code
Thread-Index: Ac2HWtLvTmsbAruWSPWDyQGXCjZerA==
Date: Fri, 31 Aug 2012 09:27:22 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F88@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is really minor, but it improves the readability.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |    3 ++-
 include/linux/platform_data/lp8727.h |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 005aaae..4db65f8 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -149,7 +149,6 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 	if (ret)
 		return ret;
 
-
 	val = LP8727_ID200_EN | LP8727_ADC_EN | LP8727_CP_EN;
 	ret = lp8727_write_byte(pchg, LP8727_CTRL1, val);
 	if (ret)
@@ -162,6 +161,7 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
+
 	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
 	return val & LP8727_DCPORT;
 }
@@ -169,6 +169,7 @@ static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
+
 	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
 	return val & LP8727_CHPORT;
 }
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index a8b8dbc..47128a5 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -38,7 +38,7 @@ enum lp8727_ichg {
 /**
  * struct lp8727_chg_param
  * @eoc_level : end of charge level setting
- * @ichg : charging current
+ * @ichg      : charging current
  */
 struct lp8727_chg_param {
 	enum lp8727_eoc_level eoc_level;
@@ -47,10 +47,10 @@ struct lp8727_chg_param {
 
 /**
  * struct lp8727_platform_data
- * @get_batt_present : check battery status - exists or not
- * @get_batt_level : get battery voltage (mV)
+ * @get_batt_present  : check battery status - exists or not
+ * @get_batt_level    : get battery voltage (mV)
  * @get_batt_capacity : get battery capacity (%)
- * @get_batt_temp : get battery temperature
+ * @get_batt_temp     : get battery temperature
  * @ac                : charging parameters for AC type charger
  * @usb               : charging parameters for USB type charger
  * @debounce_msec     : interrupt debounce time
-- 
1.7.9.5


Best Regards,
Milo


