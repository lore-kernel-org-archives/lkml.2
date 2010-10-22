Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0JVFR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:17:29 -0400
Received: from mail.perches.com ([173.55.12.10]:3464 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0JVFRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:25 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] drivers/gpu: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:13 -0700
Message-Id: <9109bfa77cbbc07631bd3dbef70ba219d4054682.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index fcc79b5..6d64a27 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -268,7 +268,7 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	}
 	r = radeon_ib_schedule(rdev, parser.ib);
 	if (r) {
-		DRM_ERROR("Faild to schedule IB !\n");
+		DRM_ERROR("Failed to schedule IB !\n");
 	}
 	radeon_cs_parser_fini(&parser, r);
 	mutex_unlock(&rdev->cs_mutex);
-- 
1.7.3.1.g432b3.dirty

