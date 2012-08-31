Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2HaJ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:27:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45283 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2HaJ1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:27:10 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/22] lp8727_charger: add description in the private data
Thread-Topic: [PATCH 20/22] lp8727_charger: add description in the private
 data
Thread-Index: Ac2HWsUZFphaQbEHTb6E6QMsSUUqBw==
Date: Fri, 31 Aug 2012 09:27:04 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F74@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: JUIW JXNC NlTR OKcC Ros4 SZAo T4b6 U728 YwXv ZPy+ cSnR
 ccm/ dbbo d3JU hNJn
 h1cB;3;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{CEF3DB20-00B0-43F4-9D3A-1F95CB07B112};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 31 Aug 2012 09:26:58
 GMT;WwBQAEEAVABDAEgAIAAyADAALwAyADIAXQAgAGwAcAA4ADcAMgA3AF8AYwBoAGEAcgBnAGUAcgA6ACAAYQBkAGQAIABkAGUAcwBjAHIAaQBwAHQAaQBvAG4AIABpAG4AIAB0AGgAZQAgAHAAcgBpAHYAYQB0AGUAIABkAGEAdABhAA==
x-cr-puzzleid: {CEF3DB20-00B0-43F4-9D3A-1F95CB07B112}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add description and relocate data.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b3295a7..772e509 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -88,13 +88,17 @@ struct lp8727_chg {
 	struct device *dev;
 	struct i2c_client *client;
 	struct mutex xfer_lock;
-	struct delayed_work work;
-	struct lp8727_platform_data *pdata;
 	struct lp8727_psy *psy;
-	struct lp8727_chg_param *chg_param;
+	struct lp8727_platform_data *pdata;
+
+	/* Charger Data */
 	enum lp8727_dev_id devid;
-	unsigned long debounce_jiffies;
+	struct lp8727_chg_param *chg_param;
+
+	/* Interrupt Handling */
 	int irq;
+	struct delayed_work work;
+	unsigned long debounce_jiffies;
 };
 
 static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
-- 
1.7.9.5


Best Regards,
Milo


