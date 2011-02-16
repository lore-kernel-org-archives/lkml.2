Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1BPGz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:55:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43670 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab1BPGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gY6AoYFJ+j0uLuVy9JzhKpzPG4paq/doe1K8NPHR8MIQhhQALe+n3N3HnFMoptBVA1
         WkaUpbNTpYVtHeHwQ/h9em6+78kh2YpvyfnnebiifbkcyldEd00AEtFugGboe5PSoaui
         WYy8y/Osytbl+izc4WsrT//ZuergzFqSLiL6w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: airlied@linux.ie, benh@kernel.crashing.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]drivers:video:aty:radeon_base Fix typo occationally to occasionally
Date: Tue, 15 Feb 2011 22:55:38 -0800
Message-Id: <1297839338-3198-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo occationally to occasionally.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
 drivers/video/aty/radeon_base.c             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index cf0638c..a883902 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -888,7 +888,7 @@ static void radeon_set_pll(struct drm_crtc *crtc, struct drm_display_mode *mode)
 		}
 
 		if (rdev->flags & RADEON_IS_MOBILITY) {
-			/* A temporal workaround for the occational blanking on certain laptop panels.
+			/* A temporal workaround for the occasional blanking on certain laptop panels.
 			   This appears to related to the PLL divider registers (fail to lock?).
 			   It occurs even when all dividers are the same with their old settings.
 			   In this case we really don't need to fiddle with PLL registers.
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 3c1e13e..32f8cf6 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -1248,7 +1248,7 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 
 	/* Workaround from XFree */
 	if (rinfo->is_mobility) {
-	        /* A temporal workaround for the occational blanking on certain laptop
+	        /* A temporal workaround for the occasional blanking on certain laptop
 		 * panels. This appears to related to the PLL divider registers
 		 * (fail to lock?). It occurs even when all dividers are the same
 		 * with their old settings. In this case we really don't need to
-- 
1.6.5.2.180.gc5b3e

