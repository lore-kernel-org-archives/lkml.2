Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab0GAVvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:51:36 -0400
Received: from kroah.org ([198.145.64.141]:60907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980Ab0GAVNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:47 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.743142612@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [075/200] drm/radeon/kms/atom: fix typo in LVDS panel info parsing
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,7 +1173,7 @@ struct radeon_encoder_atom_dig *radeon_a
 		lvds->native_mode.vtotal = lvds->native_mode.vdisplay +
 			le16_to_cpu(lvds_info->info.sLCDTiming.usVBlanking_Time);
 		lvds->native_mode.vsync_start = lvds->native_mode.vdisplay +
-			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncWidth);
+			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncOffset);
 		lvds->native_mode.vsync_end = lvds->native_mode.vsync_start +
 			le16_to_cpu(lvds_info->info.sLCDTiming.usVSyncWidth);
 		lvds->panel_pwr_delay =


