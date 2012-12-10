Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2LJF1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:27:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33657 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2LJF1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:27:15 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/4] MAINTAINERS: add LP8727 charger driver entry
Thread-Topic: [PATCH 2/4] MAINTAINERS: add LP8727 charger driver entry
Thread-Index: Ac3Wlvv1YesRM3XkSTG/UfyxiUvWXA==
Date: Mon, 10 Dec 2012 05:27:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E057FB@DQHE02.ent.ti.com>
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
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92fa7e5..a5aedda 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7558,6 +7558,12 @@ F:	Documentation/backlight/lp855x-driver.txt
 F:	drivers/video/backlight/lp855x_bl.c
 F:	include/linux/platform_data/lp855x.h
 
+TI LP8727 CHARGER DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	drivers/power/lp8727_charger.c
+F:	include/linux/platform_data/lp8727.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.9.5


Best Regards,
Milo


