Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1HAXZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab1HAXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:50 2011
Message-Id: <20110801232050.872414225@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [03/70] drm/radeon/kms: fix typo in evergreen disp int status register
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 37cba6c6f4687e694ac6e3adcf2c2b2974aa3aae upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreend.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -541,7 +541,7 @@
 #       define LB_D5_VBLANK_INTERRUPT                   (1 << 3)
 #       define DC_HPD5_INTERRUPT                        (1 << 17)
 #       define DC_HPD5_RX_INTERRUPT                     (1 << 18)
-#define DISP_INTERRUPT_STATUS_CONTINUE5                 0x6050
+#define DISP_INTERRUPT_STATUS_CONTINUE5                 0x6150
 #       define LB_D6_VLINE_INTERRUPT                    (1 << 2)
 #       define LB_D6_VBLANK_INTERRUPT                   (1 << 3)
 #       define DC_HPD6_INTERRUPT                        (1 << 17)


