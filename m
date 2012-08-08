Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab2HHTIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:08:12 -0400
Received: from 209.248.170.90.nw.nuvox.net ([209.248.170.90]:12743 "EHLO
	GVL-MAIL.koe-americas.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758679Ab2HHTIL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:08:11 -0400
From: David Cullen <David.Cullen@koe-americas.com>
To: "rob@ti.com" <rob@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix error: unknown field reclaim_buffers specified in
 initializer
Thread-Topic: [PATCH] Fix error: unknown field reclaim_buffers specified in
 initializer
Thread-Index: AQHNdZkmZ3AVNKh5AU6I7FvTGSttog==
Date: Wed, 8 Aug 2012 19:08:10 +0000
Message-ID: <5022B919.1060505@koe-americas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
x-originating-ip: [10.1.5.28]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B239BE5925429041899025AC3F977EFB@koe-americas.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reclaim_buffers field has been removed from struct drm_driver.

Signed-off-by: David Cullen <david.cullen@koe-americas.com>
---
 drivers/staging/omapdrm/omap_drv.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/omapdrm/omap_drv.c
b/drivers/staging/omapdrm/omap_drv.c
index 4beab94..44149ee 100644
--- a/drivers/staging/omapdrm/omap_drv.c
+++ b/drivers/staging/omapdrm/omap_drv.c
@@ -761,7 +761,6 @@ static struct drm_driver omap_drm_driver = {
                .irq_postinstall = dev_irq_postinstall,
                .irq_uninstall = dev_irq_uninstall,
                .irq_handler = dev_irq_handler,
-               .reclaim_buffers = drm_core_reclaim_buffers,
 #ifdef CONFIG_DEBUG_FS
                .debugfs_init = omap_debugfs_init,
                .debugfs_cleanup = omap_debugfs_cleanup,
--
1.7.9.5