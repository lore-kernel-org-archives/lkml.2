Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2LKVxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:53:13 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:43509 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2LKVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:21 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/19] MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
Date: Tue, 11 Dec 2012 19:49:52 -0200
Message-Id: <1355262601-4263-11-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to include/linux/platform_data/video-imxfb.h by
commit 82906b1 (ARM: imx: move platform_data definitions).

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bf84d4..9bc4861d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3138,7 +3138,7 @@ M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/plat-mxc/include/mach/imxfb.h
+F:	include/linux/platform_data/video-imxfb.h
 F:	drivers/video/imxfb.c
 
 FREESCALE SOC FS_ENET DRIVER
-- 
1.7.11.7

