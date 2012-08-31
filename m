Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2HaJ0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:26:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45242 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab2HaJ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:26:41 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/22] lp8727_charger: make cosmetic code on
 lp8727_delayed_func()
Thread-Topic: [PATCH 18/22] lp8727_charger: make cosmetic code on
 lp8727_delayed_func()
Thread-Index: Ac2HWrWm/CndtOiHS3ukAztRZ1sgoA==
Date: Fri, 31 Aug 2012 09:26:33 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F51@DQHE02.ent.ti.com>
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

 Declare a variable at one line and align lines.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index a01059f..62102c4 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -219,9 +219,11 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
 
 static void lp8727_delayed_func(struct work_struct *_work)
 {
-	u8 intstat[LP8788_NUM_INTREGS], idno, vbus;
-	struct lp8727_chg *pchg =
-	    container_of(_work, struct lp8727_chg, work.work);
+	struct lp8727_chg *pchg = container_of(_work, struct lp8727_chg,
+						work.work);
+	u8 intstat[LP8788_NUM_INTREGS];
+	u8 idno;
+	u8 vbus;
 
 	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, LP8788_NUM_INTREGS)) {
 		dev_err(pchg->dev, "can not read INT registers\n");
-- 
1.7.9.5


Best Regards,
Milo


