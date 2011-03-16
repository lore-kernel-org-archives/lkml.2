Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1CPUhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:37:05 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58014 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1CPUhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:37:02 -0400
Subject: [PATCH] drm: radeon: Fix printk typo 'ib poll'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 16 Mar 2011 21:36:32 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-2.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1300307820.1954.8.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 239c3d7..6709182 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -194,7 +194,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 	r = radeon_bo_kmap(rdev->ib_pool.robj, &ptr);
 	radeon_bo_unreserve(rdev->ib_pool.robj);
 	if (r) {
-		DRM_ERROR("radeon: failed to map ib poll (%d).\n", r);
+		DRM_ERROR("radeon: failed to map ib pool (%d).\n", r);
 		return r;
 	}
 	for (i = 0; i < RADEON_IB_POOL_SIZE; i++) {
-- 
1.7.4.1



