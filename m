Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2HIGty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:49:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51047 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab2HIGtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:49:53 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'Richard Purdie'" <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] backlight: lp855x: add FAST bit description for LP8556
Thread-Topic: [PATCH] backlight: lp855x: add FAST bit description for LP8556
Thread-Index: Ac11+xij+HVzYfmDSVW1u46vF1axJg==
Date: Thu, 9 Aug 2012 06:49:22 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEBC13@DBDE02.ent.ti.com>
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

LP8556 backlight driver supports fast refresh mode when exiting
the low power mode.
This bit can be configurable in the platform side.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/platform_data/lp855x.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index cc76f1f..761f317 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -46,6 +46,8 @@
 #define LP8556_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
 				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
 #define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
+#define LP8556_FAST_CONFIG	BIT(7) /* use it if EPROMs should be maintained
+					  when exiting the low power mode */
 
 enum lp855x_chip_id {
 	LP8550,
-- 
1.7.2.5


Best Regards,
Milo


