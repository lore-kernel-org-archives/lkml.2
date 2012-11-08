Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2KHNxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:53:34 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55742 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755901Ab2KHNxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:53:04 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/5] sound: Remove reference to feature-removal-schedule.txt.
Date: Thu,  8 Nov 2012 21:50:34 +0800
Message-Id: <1352382635-2773-4-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352382635-2773-1-git-send-email-tm@tao.ma>
References: <1352382402-2706-1-git-send-email-tm@tao.ma>
 <1352382635-2773-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 sound/Kconfig      |    3 ---
 sound/sound_core.c |    3 +--
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index 261a03c..c710ce2 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -52,9 +52,6 @@ config SOUND_OSS_CORE_PRECLAIM
 
 	  Disabling this allows alternative OSS implementations.
 
-	  Please read Documentation/feature-removal-schedule.txt for
-	  details.
-
 	  If unsure, say Y.
 
 source "sound/oss/dmasound/Kconfig"
diff --git a/sound/sound_core.c b/sound/sound_core.c
index fb9255c..bb23009 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -146,8 +146,7 @@ extern int msnd_pinnacle_init(void);
  * devices only the standard chrdev aliases are requested.
  *
  * All these clutters are scheduled to be removed along with
- * sound-slot/service-* module aliases.  Please take a look at
- * feature-removal-schedule.txt for details.
+ * sound-slot/service-* module aliases.
  */
 #ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
 static int preclaim_oss = 1;
-- 
1.7.0.4

