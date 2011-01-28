Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1A1W7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:59:04 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:44845 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1A1W7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:59:03 -0500
X-Greylist: delayed 1571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 17:59:03 EST
Subject: [PATCH] [TRIVIAL] Fix printk typo 'sracth'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Jan 2011 23:32:13 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1296254002.4019.5.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/r100.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 57faec9..3889bb6 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3521,7 +3521,7 @@ int r100_ring_test(struct radeon_device *rdev)
 	if (i < rdev->usec_timeout) {
 		DRM_INFO("ring test succeeded in %d usecs\n", i);
 	} else {
-		DRM_ERROR("radeon: ring test failed (sracth(0x%04X)=0x%08X)\n",
+		DRM_ERROR("radeon: ring test failed (scratch(0x%04X)=0x%08X)\n",
 			  scratch, tmp);
 		r = -EINVAL;
 	}
@@ -3583,7 +3583,7 @@ int r100_ib_test(struct radeon_device *rdev)
 	if (i < rdev->usec_timeout) {
 		DRM_INFO("ib test succeeded in %u usecs\n", i);
 	} else {
-		DRM_ERROR("radeon: ib test failed (sracth(0x%04X)=0x%08X)\n",
+		DRM_ERROR("radeon: ib test failed (scratch(0x%04X)=0x%08X)\n",
 			  scratch, tmp);
 		r = -EINVAL;
 	}
-- 
1.7.3.5



