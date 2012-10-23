Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab2JWUf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:35:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56177 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933845Ab2JWUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, William Light <wrl@illest.net>,
        Torsten Schenk <torsten.schenk@zoho.com>
Subject: [PATCH 191/193] sound/usb: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:24 -0700
Message-Id: <1351022666-6960-192-git-send-email-keescook@chromium.org>
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

CC: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
CC: William Light <wrl@illest.net>
CC: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/usb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index ff77b28..225dfd7 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -90,7 +90,7 @@ config SND_USB_CAIAQ_INPUT
 
 config SND_USB_US122L
 	tristate "Tascam US-122L USB driver"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select SND_HWDEP
 	select SND_RAWMIDI
 	help
-- 
1.7.9.5

