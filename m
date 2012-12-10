Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2LJF1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:27:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50227 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2LJF11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:27:27 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: [PATCH 3/4] MAINTAINERS: add LP872x regulator driver entry
Thread-Topic: [PATCH 3/4] MAINTAINERS: add LP872x regulator driver entry
Thread-Index: Ac3WlwZ09WKxKtUBR1Cg9qzd0m57HQ==
Date: Mon, 10 Dec 2012 05:27:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E05805@DQHE02.ent.ti.com>
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

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a5aedda..ee7e9ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7564,6 +7564,12 @@ S:	Maintained
 F:	drivers/power/lp8727_charger.c
 F:	include/linux/platform_data/lp8727.h
 
+TI LP872X REGULATOR DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	drivers/regulator/lp872x.c
+F:	include/linux/regulator/lp872x.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.9.5


Best Regards,
Milo


