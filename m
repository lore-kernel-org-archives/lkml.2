Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0GAUu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:50:57 -0400
Received: from kroah.org ([198.145.64.141]:47426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab0GAUuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:31 2010
Message-Id: <20100701173431.632677893@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 057/164] drm/radeon/kms/atom: fix typo in LVDS panel info parsing
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 1ff26a3604d0292988d4cade0e49ba9918dbfd46 upstream.

Fixes LVDS issues on some laptops; notably laptops with
2048x1536 panels.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1136,7 +1136,7 @@ struct radeon_encoder_atom_dig *radeon_a
 		lvds->native_mode.vtotal = lvds->native_mode.vdisplay +
 			le16_to_cpu(lvds_info->info.sLCDTiming.usVBlanking_Time);
 		lvds->native_mode.vsync_start = lvds->native_mode.vdisplay +
-			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncWidth);
+			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncOffset);
 		lvds->native_mode.vsync_end = lvds->native_mode.vsync_start +
 			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncWidth);
 		lvds->panel_pwr_delay =


