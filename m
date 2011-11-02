Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1KBCdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:33:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51408 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1KBCdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:33:06 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-3e-4eb0abe02c3f
Date: Wed, 02 Nov 2011 11:33:16 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        inki.dae@samsung.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] DRM: EXYNOS: Add EXYNOS DRM maintainer entry
Message-id: <20111102023316.GA23401@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 02 Nov 2011 02:32:49.0729 (UTC)
 FILETIME=[B6C81B10:01CC9907]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

As Exynos DRM is merged at mainline. Also update the maintainer entry.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 5d6941f..1deeac9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2327,6 +2327,13 @@ S:	Supported
 F:	drivers/gpu/drm/i915
 F:	include/drm/i915*
 
+DRM DRIVERS FOR EXYNOS
+M:	Inki Dae <inki.dae@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/exynos
+F:	include/drm/exynos*
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
