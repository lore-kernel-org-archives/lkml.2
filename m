Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab2DKWFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:05:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17878 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab2DKWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:05:32 -0400
Date: Thu, 12 Apr 2012 00:05:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, Alan Cox <alan@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Airlie <airlied@linux.ie>, jim liu <jim.liu@intel.com>,
        Jackie Li <yaodong.li@intel.com>, trivial@kernel.org
Subject: [PATCH] gma500: Don't needlessly include version.h in
 mdfld_dsi_output.h
Message-ID: <alpine.LNX.2.00.1204120002390.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/gma500/mdfld_dsi_output.h does not need to
'#include <linux/version.h>' - so don't.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.h b/drivers/gpu/drm/gma500/mdfld_dsi_output.h
index 21071ce..36eb074 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.h
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.h
@@ -29,7 +29,6 @@
 #define __MDFLD_DSI_OUTPUT_H__
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include <drm/drm_crtc.h>
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

