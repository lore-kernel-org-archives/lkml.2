Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1HAXgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:36:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab1HAXZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232050.976425358@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [04/70] drm/radeon/kms: fix typo in IH_CNTL swap bitfield
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit fcb857abc4c0d512e99a08ba0415be9a6d65b4c0 upstream.

Only affects BE systems.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreend.h |    2 +-
 drivers/gpu/drm/radeon/r600d.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -460,7 +460,7 @@
 #define IH_RB_WPTR_ADDR_LO                                0x3e14
 #define IH_CNTL                                           0x3e18
 #       define ENABLE_INTR                                (1 << 0)
-#       define IH_MC_SWAP(x)                              ((x) << 2)
+#       define IH_MC_SWAP(x)                              ((x) << 1)
 #       define IH_MC_SWAP_NONE                            0
 #       define IH_MC_SWAP_16BIT                           1
 #       define IH_MC_SWAP_32BIT                           2
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -536,7 +536,7 @@
 #define IH_RB_WPTR_ADDR_LO                                0x3e14
 #define IH_CNTL                                           0x3e18
 #       define ENABLE_INTR                                (1 << 0)
-#       define IH_MC_SWAP(x)                              ((x) << 2)
+#       define IH_MC_SWAP(x)                              ((x) << 1)
 #       define IH_MC_SWAP_NONE                            0
 #       define IH_MC_SWAP_16BIT                           1
 #       define IH_MC_SWAP_32BIT                           2


