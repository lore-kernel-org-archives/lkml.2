Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1CPUhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:37:51 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58234 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1CPUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:37:45 -0400
Subject: [PATCH] [TRIVIAL] drm: radeon: Turn a printk into a meaningful
 sentence
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 16 Mar 2011 21:37:16 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-2.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1300307864.1954.9.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 239c3d7..322cdb7 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -179,7 +179,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 			     PAGE_SIZE, true, RADEON_GEM_DOMAIN_GTT,
 			     &rdev->ib_pool.robj);
 	if (r) {
-		DRM_ERROR("radeon: failed to ib pool (%d).\n", r);
+		DRM_ERROR("radeon: failed to create ib pool (%d).\n", r);
 		return r;
 	}
 	r = radeon_bo_reserve(rdev->ib_pool.robj, false);
-- 
1.7.4.1



