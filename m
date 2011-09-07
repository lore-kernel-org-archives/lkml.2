Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1IGQWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:22:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:1216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab1IGQVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,345,1312182000"; 
   d="scan'208";a="50027820"
Subject: [PATCH] drm: Remove duplicate "return" statement
From: Lin Ming <ming.m.lin@intel.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 07 Sep 2011 22:58:09 +0800
Message-ID: <1315407489.4321.4.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the duplicate "return" statement in drm_fb_helper_panic().

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 802b61a..f7c6854 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -256,7 +256,6 @@ int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
 {
 	printk(KERN_ERR "panic occurred, switching back to text console\n");
 	return drm_fb_helper_force_kernel_mode();
-	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_panic);
 
-- 
1.7.2.5



