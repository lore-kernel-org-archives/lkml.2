Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1I1WoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab1I1WoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.453112165@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 18b4fada275dd2b6dd9db904ddf70fe39e272222 upstream.

cur_pages is the number of pages per loop iteration.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -773,8 +773,8 @@ int r100_copy_blit(struct radeon_device
 		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
 		radeon_ring_write(rdev, 0);
 		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
-		radeon_ring_write(rdev, num_pages);
-		radeon_ring_write(rdev, num_pages);
+		radeon_ring_write(rdev, cur_pages);
+		radeon_ring_write(rdev, cur_pages);
 		radeon_ring_write(rdev, cur_pages | (stride_pixels << 16));
 	}
 	radeon_ring_write(rdev, PACKET0(RADEON_DSTCACHE_CTLSTAT, 0));


