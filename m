Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2B0O2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:28:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2B0O2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:28:44 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: benh@kernel.crashing.org, linux-fbdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] radeon: Fix typo in radeon_gem.c
Date: Mon, 27 Feb 2012 23:28:38 +0900
Message-Id: <1330352918-1738-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.9.2.262.gba998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "withou" to "without" in
drivers/gpu/drm/radeon/radeon_gem.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 7337850..ff4ff23 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -117,7 +117,7 @@ int radeon_gem_set_domain(struct drm_gem_object *gobj,
 	}
 	if (!domain) {
 		/* Do nothings */
-		printk(KERN_WARNING "Set domain withou domain !\n");
+		printk(KERN_WARNING "Set domain without domain !\n");
 		return 0;
 	}
 	if (domain == RADEON_GEM_DOMAIN_CPU) {
-- 
1.7.9.2.262.gba998

