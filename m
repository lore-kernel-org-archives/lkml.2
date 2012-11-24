Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2KXAav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:30:51 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:52930 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab2KXA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:32 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Sascha Hauer <kernel@pengutronix.de>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/24] MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
Date: Fri, 23 Nov 2012 22:26:35 -0200
Message-Id: <1353716808-16375-12-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to include/linux/platform_data/video-imxfb.h by
commit 82906b1 (ARM: imx: move platform_data definitions).

Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a67a67a..887d717 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3137,7 +3137,7 @@ M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/plat-mxc/include/mach/imxfb.h
+F:	include/linux/platform_data/video-imxfb.h
 F:	drivers/video/imxfb.c
 
 FREESCALE SOC FS_ENET DRIVER
-- 
1.7.11.7

