Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1EZIkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:40:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26096 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1EZIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:40:21 -0400
Date: Thu, 26 May 2011 10:32:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [Patch][Trivial] sound, soc, codec, WM8915: Remove duplicate
 linux/delay.h inclusion.
Message-ID: <alpine.LNX.2.00.1105261028060.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's enough to include linux/delay.h just once in 
sound/soc/codecs/wm8915.c, so remove the duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 wm8915.c |    1 -
 1 file changed, 1 deletion(-)

 Patch against Linus' tree as of a few minutes ago.

diff --git a/sound/soc/codecs/wm8915.c b/sound/soc/codecs/wm8915.c
index ccc9bd8..a0b1a72 100644
--- a/sound/soc/codecs/wm8915.c
+++ b/sound/soc/codecs/wm8915.c
@@ -19,7 +19,6 @@
 #include <linux/gcd.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

