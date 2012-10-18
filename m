Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2JRGME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:12:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41915 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2JRGMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:12:01 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] lp8788-charger: fix ADC channel names
Thread-Topic: [PATCH 2/3] lp8788-charger: fix ADC channel names
Thread-Index: Ac2s93JcsmYrNrJMT1e2Ylkwid0fcg==
Date: Thu, 18 Oct 2012 06:11:44 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64178F9F@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 LP8788 IIO ADC driver and platform data have specific naming convention
 for ADC channels. That is using prefix 'lp8788_'.
 To keep this rule, ADC channel names are changed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 614e6aa..02fc9ab 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -600,13 +600,13 @@ static void lp8788_setup_adc_channel(const char *consumer_name,
 	struct iio_channel *chan;
 	enum lp8788_adc_id id;
 	const char *chan_name[LPADC_MAX] = {
-		[LPADC_VBATT_5P5] = "vbatt-5p5",
-		[LPADC_VBATT_6P0] = "vbatt-6p0",
-		[LPADC_VBATT_5P0] = "vbatt-5p0",
-		[LPADC_ADC1]      = "adc1",
-		[LPADC_ADC2]      = "adc2",
-		[LPADC_ADC3]      = "adc3",
-		[LPADC_ADC4]      = "adc4",
+		[LPADC_VBATT_5P5] = "lp8788_vbatt_5p5",
+		[LPADC_VBATT_6P0] = "lp8788_vbatt_6p0",
+		[LPADC_VBATT_5P0] = "lp8788_vbatt_5p0",
+		[LPADC_ADC1]      = "lp8788_adc1",
+		[LPADC_ADC2]      = "lp8788_adc2",
+		[LPADC_ADC3]      = "lp8788_adc3",
+		[LPADC_ADC4]      = "lp8788_adc4",
 	};
 
 	if (!pdata)
-- 
1.7.9.5


Best Regards,
Milo


