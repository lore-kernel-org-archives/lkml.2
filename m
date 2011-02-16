Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab1BPBvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:48 -0500
Received: from kroah.org ([198.145.64.141]:49162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758495Ab1BPBvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:02 2011
Message-Id: <20110216014702.158688059@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [079/115] drm/radeon/kms: add pll debugging output
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 51d4bf840a27fe02c883ddc6d9708af056773769 upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -540,6 +540,10 @@ void radeon_compute_pll(struct radeon_pl
 	*frac_fb_div_p = best_frac_feedback_div;
 	*ref_div_p = best_ref_div;
 	*post_div_p = best_post_div;
+	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
+		      best_ref_div, best_post_div);
+
 }
 
 static void radeon_user_framebuffer_destroy(struct drm_framebuffer *fb)


