Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0G0CdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 22:33:23 -0400
Received: from smtp-out-074.synserver.de ([212.40.180.74]:1040 "HELO
	smtp-out-074.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751430Ab0G0CdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 22:33:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27729
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] fbdev: Make jz4740-fb depends on MACH_JZ4740
Date: Tue, 27 Jul 2010 04:32:59 +0200
Message-Id: <1280197979-24307-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20100727111422.673b4919.sfr@canb.auug.org.au>
References: <20100727111422.673b4919.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jz4740-fb driver should only be selectabed of MACH_JZ4740 is selected.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a42cb9b..9e711a1 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2231,7 +2231,7 @@ config FB_BROADSHEET
 
 config FB_JZ4740
 	tristate "JZ4740 LCD framebuffer support"
-	depends on FB
+	depends on FB && MACH_JZ4740
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
-- 
1.5.6.5

