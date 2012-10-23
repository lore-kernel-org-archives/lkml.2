Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2JWUJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:09:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58911 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964887Ab2JWUIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:08:13 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 064/193] drivers/media/video/cx25821: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:17 -0700
Message-Id: <1351022666-6960-65-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/pci/cx25821/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 5f6b542..4017c94 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -18,7 +18,7 @@ config VIDEO_CX25821
 
 config VIDEO_CX25821_ALSA
 	tristate "Conexant 25821 DMA audio support"
-	depends on VIDEO_CX25821 && SND && EXPERIMENTAL
+	depends on VIDEO_CX25821 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
-- 
1.7.9.5

