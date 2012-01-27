Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2A0X5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:57:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:33826 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2A0X5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:57:32 -0500
Date: Sat, 28 Jan 2012 00:57:42 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: [PATCH] Sound, SoC, WM9090: Remove unused variable 'wm9090' from
 wm9090_i2c_remove()
Message-ID: <alpine.LNX.2.00.1201280055410.13952@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'wm9090' is assigned to but never used, so let's just
remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/wm9090.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

	compile teste only

diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index 41ebe0d..db1ba30 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -655,10 +655,7 @@ static int wm9090_i2c_probe(struct i2c_client *i2c,
 
 static int __devexit wm9090_i2c_remove(struct i2c_client *i2c)
 {
-	struct wm9090_priv *wm9090 = i2c_get_clientdata(i2c);
-
 	snd_soc_unregister_codec(&i2c->dev);
-
 	return 0;
 }
 
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

