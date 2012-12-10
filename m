Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2LJF2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:28:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2LJF2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:28:11 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/4] MAINTAINERS: add LP8788 MFD driver entry
Thread-Topic: [PATCH 4/4] MAINTAINERS: add LP8788 MFD driver entry
Thread-Index: Ac3Wlxtu5fUVXpTAT86WxVl080nt+w==
Date: Mon, 10 Dec 2012 05:27:55 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0581F@DQHE02.ent.ti.com>
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

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ee7e9ee..9339a4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7570,6 +7570,16 @@ S:	Maintained
 F:	drivers/regulator/lp872x.c
 F:	include/linux/regulator/lp872x.h
 
+TI LP8788 MFD DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	drivers/iio/adc/lp8788_adc.c
+F:	drivers/leds/leds-lp8788.c
+F:	drivers/mfd/lp8788*.c
+F:	drivers/power/lp8788-charger.c
+F:	drivers/regulator/lp8788-*.c
+F:	include/linux/mfd/lp8788*.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.9.5


Best Regards,
Milo


