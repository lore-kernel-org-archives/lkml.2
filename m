Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1FCAeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:34:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44791 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1FCAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hviRnrnKKshbz/2tcpn6/PdwxYs7tG2AB2+fsQgUU0aLsm5w5zzUTCDGqGSoaNz2cM
         cDdka4GkfRDhDXViR1qTU15BKmYHYx+tAWDlQL8GC2O2s/5Ktci2+X/nIOC+GSMFiqac
         hVY1iXc6z7tGqisFEyVZGmCSZy3biwwPi27QQ=
From: Curtis McEnroe <programble@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>
Subject: [PATCH 5/5] [media] tm6000: Cleaned up code style in tm6000-alsa.c
Date: Thu,  2 Jun 2011 20:33:34 -0400
Message-Id: <1307061214-14837-4-git-send-email-programble@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307061214-14837-1-git-send-email-programble@gmail.com>
References: <1307061214-14837-1-git-send-email-programble@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all errors but one (possibly a mistake by the checker) reported by
the checker.

Signed-off-by: Curtis McEnroe <programble@gmail.com>
---
 drivers/staging/tm6000/tm6000-alsa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 2b96047..ddfd7c3 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <asm/delay.h>
+#include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -255,7 +255,7 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 			length * stride);
 
 #ifndef NO_PCM_LOCK
-       snd_pcm_stream_lock(substream);
+	snd_pcm_stream_lock(substream);
 #endif
 
 	chip->buf_pos += length;
@@ -269,7 +269,7 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 	}
 
 #ifndef NO_PCM_LOCK
-       snd_pcm_stream_unlock(substream);
+	snd_pcm_stream_unlock(substream);
 #endif
 
 	if (period_elapsed)
@@ -461,7 +461,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 	if (rc < 0)
 		goto error_chip;
 
-	dprintk(1,"Registered audio driver for %s\n", card->longname);
+	dprintk(1, "Registered audio driver for %s\n", card->longname);
 
 	return 0;
 
-- 
1.7.5.2

