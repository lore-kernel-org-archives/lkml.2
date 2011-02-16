Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1BPAwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:52:10 -0500
Received: from kroah.org ([198.145.64.141]:46258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333Ab1BPAv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:15 2011
Message-Id: <20110216002115.302508011@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 163/176] drm/radeon/kms: add pll debugging output
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
@@ -629,6 +629,10 @@ static void radeon_compute_pll_legacy(st
 	*frac_fb_div_p = best_frac_feedback_div;
 	*ref_div_p = best_ref_div;
 	*post_div_p = best_post_div;
+	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
+		      best_ref_div, best_post_div);
+
 }
 
 static bool


