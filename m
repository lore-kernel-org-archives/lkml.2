Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2DSVFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:05:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2DSVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:04:58 -0400
Message-Id: <20120419210303.390155360@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Armin Reese <armin.c.reese@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 03/75] drm/i915: Removed IVB forced enable of sprite dest key.
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: acreese <armin.c.reese@intel.com>

commit b2a71642b8bfa1965700ba248a99016e4d6b685d upstream.

The destination color key is always enabled for IVB.  Removed
the line that does this.

Signed-off-by: Armin Reese <armin.c.reese@intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sprite.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -95,7 +95,6 @@ ivb_update_plane(struct drm_plane *plane
 	/* must disable */
 	sprctl |= SPRITE_TRICKLE_FEED_DISABLE;
 	sprctl |= SPRITE_ENABLE;
-	sprctl |= SPRITE_DEST_KEY;
 
 	/* Sizes are 0 based */
 	src_w--;


