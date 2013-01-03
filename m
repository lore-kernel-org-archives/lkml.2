Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3ACGcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:32:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39125 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3ACGcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:32:10 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] lp8788-buck: fix a for-loop coding style
Thread-Topic: [PATCH 3/5] lp8788-buck: fix a for-loop coding style
Thread-Index: Ac3pfAoUi8VaEgtXQgCDO9sa1KnTNg==
Date: Thu, 3 Jan 2013 06:32:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1101C@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove space before semicolon in for-loop.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-buck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 98770e8..1161949 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -449,7 +449,7 @@ static int lp8788_dvs_gpio_request(struct platform_device *pdev,
 		buck->dvs = pdata->buck1_dvs;
 		break;
 	case BUCK2:
-		for (i = 0 ; i < LP8788_NUM_BUCK2_DVS ; i++) {
+		for (i = 0; i < LP8788_NUM_BUCK2_DVS; i++) {
 			gpio = pdata->buck2_dvs->gpio[i];
 			ret = devm_gpio_request_one(&pdev->dev, gpio,
 						    DVS_LOW, b2_name[i]);
-- 
1.7.9.5


Best Regards,
Milo


