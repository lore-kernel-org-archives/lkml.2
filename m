Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2ICDEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:04:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54280 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2ICDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:04:22 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 20:04:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] sound: Remove the last mention of SNDRV_MAIN_OBJECT_FILE
Message-ID: <20120903030415.GA20377@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNDRV_MAIN_OBJECT_FILE hasn't done anything since the pre-git days, and
the only remaining reference occurs as a #define in sound/last.c.  Drop
that last mention of it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 sound/last.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/last.c b/sound/last.c
index 7ffc182..43f2228 100644
--- a/sound/last.c
+++ b/sound/last.c
@@ -19,7 +19,6 @@
  *
  */
 
-#define SNDRV_MAIN_OBJECT_FILE
 #include <linux/init.h>
 #include <sound/core.h>
 
-- 
1.7.10.4

