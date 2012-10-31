Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257Ab2J3SMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:12:49 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59041 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965211Ab2J3SMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:41 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] da8xx: Allow use by am33xx based devices
Date: Wed, 31 Oct 2012 17:56:08 +0200
Message-Id: <1351698968-3965-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be used for AM33xx devices, like the popular beaglebone.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/video/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9791d10..e7868d8 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2202,7 +2202,7 @@ config FB_SH7760
 
 config FB_DA8XX
 	tristate "DA8xx/OMAP-L1xx Framebuffer support"
-	depends on FB && ARCH_DAVINCI_DA8XX
+	depends on FB && (ARCH_DAVINCI_DA8XX || SOC_AM33XX)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.12

