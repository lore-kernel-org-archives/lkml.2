Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1BRJGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:06:55 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56410 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab1BRJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:05:01 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 3/7] drm/radeon/kms: add pll debugging output" has been added to staging queue
Date: Fri, 18 Feb 2011 10:04:59 +0100
Message-Id: <1298019899-2376-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 3/7] drm/radeon/kms: add pll debugging output

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 87c83dfc5e5b706f9a4600e147b4cc47a611dca4 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 31 Jan 2011 16:48:51 -0500
Subject: [PATCH 3/7] drm/radeon/kms: add pll debugging output

commit 51d4bf840a27fe02c883ddc6d9708af056773769 upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_display.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 7e17a36..567bd8e 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -578,6 +578,10 @@ void radeon_compute_pll(struct radeon_pll *pll,
 	*frac_fb_div_p = best_frac_feedback_div;
 	*ref_div_p = best_ref_div;
 	*post_div_p = best_post_div;
+	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
+		      best_ref_div, best_post_div);
+
 }

 void radeon_compute_pll_avivo(struct radeon_pll *pll,
--
1.7.0.4

