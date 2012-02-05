Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2BEOCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:02:43 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:44921
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413Ab2BEOCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:02:21 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] drm: Fix typo in rv515.c
Date: Sun,  5 Feb 2012 23:01:34 +0900
Message-Id: <1328450494-1970-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/gpu/drm/radeon/rv515.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/radeon/rv515.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 880637f..8787b18 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -150,7 +150,7 @@ void rv515_gpu_init(struct radeon_device *rdev)
 
 	if (r100_gui_wait_for_idle(rdev)) {
 		printk(KERN_WARNING "Failed to wait GUI idle while "
-		       "reseting GPU. Bad things might happen.\n");
+		       "resetting GPU. Bad things might happen.\n");
 	}
 	rv515_vga_render_disable(rdev);
 	r420_pipes_init(rdev);
@@ -162,7 +162,7 @@ void rv515_gpu_init(struct radeon_device *rdev)
 	WREG32_PLL(0x000D, tmp);
 	if (r100_gui_wait_for_idle(rdev)) {
 		printk(KERN_WARNING "Failed to wait GUI idle while "
-		       "reseting GPU. Bad things might happen.\n");
+		       "resetting GPU. Bad things might happen.\n");
 	}
 	if (rv515_mc_wait_for_idle(rdev)) {
 		printk(KERN_WARNING "Failed to wait MC idle while "
-- 
1.7.6.5

