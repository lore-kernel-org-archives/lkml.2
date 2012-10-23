Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab2JWUgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37925 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933836Ab2JWUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 189/193] sound/pci/hda: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:22 -0700
Message-Id: <1351022666-6960-190-git-send-email-keescook@chromium.org>
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
 sound/pci/hda/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index 7105c3d..6eeb889 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -37,8 +37,8 @@ config SND_HDA_HWDEP
 	  with codecs for debugging purposes.
 
 config SND_HDA_RECONFIG
-	bool "Allow dynamic codec reconfiguration (EXPERIMENTAL)"
-	depends on SND_HDA_HWDEP && EXPERIMENTAL
+	bool "Allow dynamic codec reconfiguration"
+	depends on SND_HDA_HWDEP
 	help
 	  Say Y here to enable the HD-audio codec re-configuration feature.
 	  This adds the sysfs interfaces to allow user to clear the whole
@@ -72,7 +72,6 @@ config SND_HDA_INPUT_JACK
 
 config SND_HDA_PATCH_LOADER
 	bool "Support initialization patch loading for HD-audio"
-	depends on EXPERIMENTAL
 	select FW_LOADER
 	select SND_HDA_HWDEP
 	select SND_HDA_RECONFIG
-- 
1.7.9.5

