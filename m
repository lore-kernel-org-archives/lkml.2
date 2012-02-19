Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2BSPMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:12:06 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:46544 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2BSPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 5/5] fbdev: s/#if CONFIG/#ifdef CONFIG/
Date: Sun, 19 Feb 2012 16:11:59 +0100
Message-Id: <1329664319-3128-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/au1100fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index de9da67..4da1895 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -532,7 +532,7 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
 	for (page = (unsigned long)fbdev->fb_mem;
 	     page < PAGE_ALIGN((unsigned long)fbdev->fb_mem + fbdev->fb_len);
 	     page += PAGE_SIZE) {
-#if CONFIG_DMA_NONCOHERENT
+#ifdef CONFIG_DMA_NONCOHERENT
 		SetPageReserved(virt_to_page(CAC_ADDR((void *)page)));
 #else
 		SetPageReserved(virt_to_page(page));
-- 
1.7.0.4

