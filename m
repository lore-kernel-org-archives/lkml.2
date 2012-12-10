Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2LJF1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:27:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40123 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2LJF1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:27:00 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 1/4] MAINTAINERS: add LP855x backlight driver entry
Thread-Topic: [PATCH 1/4] MAINTAINERS: add LP855x backlight driver entry
Thread-Index: Ac3WlvNwkomWkHRwSvyYyvqbCoQt9Q==
Date: Mon, 10 Dec 2012 05:26:49 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E057F3@DQHE02.ent.ti.com>
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

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8110ccd..92fa7e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7551,6 +7551,13 @@ S:	Maintained
 F:	sound/soc/codecs/lm49453*
 F:	sound/soc/codecs/isabelle*
 
+TI LP855x BACKLIGHT DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	Documentation/backlight/lp855x-driver.txt
+F:	drivers/video/backlight/lp855x_bl.c
+F:	include/linux/platform_data/lp855x.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.9.5


Best Regards,
Milo

