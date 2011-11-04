Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1KDMMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:12:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23338 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1KDMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:54 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-07-4eb3d6105b31
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 01/10] drm/exynos: added padding to be 64-bit align.
Date: Fri, 04 Nov 2011 21:09:50 +0900
Message-id: <1320408599-7475-2-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0122 (UTC)
 FILETIME=[9FD14AA0:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inki Dae <inki.dae@samsung.com>

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/drm/exynos_drm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
index 874c4d2..1d161cb 100644
--- a/include/drm/exynos_drm.h
+++ b/include/drm/exynos_drm.h
@@ -36,11 +36,13 @@
  *	- this size value would be page-aligned internally.
  * @flags: user request for setting memory type or cache attributes.
  * @handle: returned handle for the object.
+ * @pad: just padding to be 64-bit aligned.
  */
 struct drm_exynos_gem_create {
 	unsigned int size;
 	unsigned int flags;
 	unsigned int handle;
+	unsigned int pad;
 };
 
 /**
-- 
1.7.4.1

