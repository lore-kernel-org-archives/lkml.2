Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2HJSNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:13:00 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:25727 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857Ab2HJSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:12:59 -0400
Date: Fri, 10 Aug 2012 20:12:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Vishwas A Deshpande <vishwas.a.deshpande@ti.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>, trivial@kernel.org
Subject: [PATCH][trivial] ASoC: isabelle: Remove unneeded include of
 version.h
Message-ID: <alpine.LNX.2.00.1208102010480.17673@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to include version.h in sound/soc/codecs/isabelle.c -
this patch removes the pointless include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/isabelle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/isabelle.c b/sound/soc/codecs/isabelle.c
index 5d8f39e..1bf5560 100644
--- a/sound/soc/codecs/isabelle.c
+++ b/sound/soc/codecs/isabelle.c
@@ -13,7 +13,6 @@
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

