Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab2JWUej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:34:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51225 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933849Ab2JWUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:36 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 187/193] sound/drivers: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:20 -0700
Message-Id: <1351022666-6960-188-git-send-email-keescook@chromium.org>
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
CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/drivers/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
index fe5ae09..5e43841 100644
--- a/sound/drivers/Kconfig
+++ b/sound/drivers/Kconfig
@@ -35,7 +35,6 @@ config SND_PCSP
 	tristate "PC-Speaker support (READ HELP!)"
 	depends on PCSPKR_PLATFORM && X86 && HIGH_RES_TIMERS
 	depends on INPUT
-	depends on EXPERIMENTAL
 	select SND_PCM
 	help
 	  If you don't have a sound card in your computer, you can include a
-- 
1.7.9.5

