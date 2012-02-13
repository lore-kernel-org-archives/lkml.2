Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2BMOLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:11:12 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35045
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751106Ab2BMOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:11:11 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        dri-devel@lists.freedesktop.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] drm: Fix typo in exynos_mixer.c
Date: Mon, 13 Feb 2012 23:10:42 +0900
Message-Id: <1329142242-2344-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "sucessful" to "successful" in
drivers/gpu/drm/exynos/exynos_mixer.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/exynos/exynos_mixer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index ac24cff..33afd0c 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1044,7 +1044,7 @@ static int mixer_remove(struct platform_device *pdev)
 					platform_get_drvdata(pdev);
 	struct mixer_context *ctx = (struct mixer_context *)drm_hdmi_ctx->ctx;
 
-	dev_info(dev, "remove sucessful\n");
+	dev_info(dev, "remove successful\n");
 
 	mixer_resource_poweroff(ctx);
 	mixer_resources_cleanup(ctx);
-- 
1.7.6.5

