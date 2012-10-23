Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab2JWUgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54500 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837Ab2JWUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 188/193] sound/isa: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:21 -0700
Message-Id: <1351022666-6960-189-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/isa/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index a38d964..affa134 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -425,7 +425,7 @@ config SND_WAVEFRONT
 
 config SND_MSND_PINNACLE
 	tristate "Turtle Beach MultiSound Pinnacle/Fiji driver"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select FW_LOADER
 	select SND_MPU401_UART
 	select SND_PCM
@@ -438,7 +438,7 @@ config SND_MSND_PINNACLE
 
 config SND_MSND_CLASSIC
 	tristate "Support for Turtle Beach MultiSound Classic, Tahiti, Monterey"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select FW_LOADER
 	select SND_MPU401_UART
 	select SND_PCM
-- 
1.7.9.5

