Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2HaJ1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:27:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2HaJ1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:27:18 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/22] lp8727_charger: fix checkpatch warning
Thread-Topic: [PATCH 21/22] lp8727_charger: fix checkpatch warning
Thread-Index: Ac2HWstne7H8b3AnRPGp3PXbjNbMxg==
Date: Fri, 31 Aug 2012 09:27:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F80@DQHE02.ent.ti.com>
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

 Fix the warning on MODULE_AUTHOR.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 772e509..005aaae 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -547,6 +547,5 @@ static struct i2c_driver lp8727_driver = {
 module_i2c_driver(lp8727_driver);
 
 MODULE_DESCRIPTION("TI/National Semiconductor LP8727 charger driver");
-MODULE_AUTHOR("Woogyom Kim <milo.kim@ti.com>, "
-	      "Daniel Jeong <daniel.jeong@ti.com>");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5


Best Regards,
Milo


