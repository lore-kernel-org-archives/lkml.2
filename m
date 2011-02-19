Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1BSVec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 16:34:32 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34503 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1BSVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 16:34:31 -0500
Subject: [PATCH] drm: fix printk typo 'sracth'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Date: Sat, 19 Feb 2011 22:34:00 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1298151270.1977.5.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
A similar patch was sent three weeks ago, this version is rebased
against current for-next.

 drivers/gpu/drm/radeon/r100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index ac493ec..a78d09f 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3584,7 +3584,7 @@ int r100_ib_test(struct radeon_device *rdev)
 	if (i < rdev->usec_timeout) {
 		DRM_INFO("ib test succeeded in %u usecs\n", i);
 	} else {
-		DRM_ERROR("radeon: ib test failed (sracth(0x%04X)=0x%08X)\n",
+		DRM_ERROR("radeon: ib test failed (scratch(0x%04X)=0x%08X)\n",
 			  scratch, tmp);
 		r = -EINVAL;
 	}
-- 
1.7.4.1



