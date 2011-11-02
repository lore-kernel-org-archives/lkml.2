Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1KCB7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:59:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934217Ab1KCBj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.153000450@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [027/101] drm/radeon/kms: fix typo in r100_blit_copy
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -496,8 +496,8 @@ int r100_copy_blit(struct radeon_device
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


