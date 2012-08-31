Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2HaJZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:25:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44016 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2HaJZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:25:40 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/22] lp8727_charger: make lp8727_init_device() shorter
Thread-Topic: [PATCH 13/22] lp8727_charger: make lp8727_init_device() shorter
Thread-Index: Ac2HWpJtnTC9wRKiTAeddto8SmL+ig==
Date: Fri, 31 Aug 2012 09:25:34 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F10@DQHE02.ent.ti.com>
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

 Return as the result of writing register.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 658518b..47cce41 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -152,11 +152,7 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 		return ret;
 
 	val = LP8727_INT_EN | LP8727_CHGDET_EN;
-	ret = lp8727_write_byte(pchg, LP8727_CTRL2, val);
-	if (ret)
-		return ret;
-
-	return 0;
+	return lp8727_write_byte(pchg, LP8727_CTRL2, val);
 }
 
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
-- 
1.7.9.5


Best Regards,
Milo


