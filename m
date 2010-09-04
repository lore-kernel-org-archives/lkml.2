Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0IDNMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:12:14 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:55602 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0IDNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:12:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Liam Girdwood <lg@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH 1/1] SOUND: wm8753, remove dead code
Date: Sat,  4 Sep 2010 15:12:09 +0200
Message-Id: <1283605929-15961-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is adangling code in wm8753_probe which is never executed.
Remove it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
---
 sound/soc/codecs/wm8753.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index 4844232..4a945d3 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1600,9 +1600,6 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 	wm8753_add_widgets(codec);
 
 	return 0;
-
-	run_delayed_work(&codec->delayed_work);
-	return ret;
 }
 
 /* power down chip */
-- 
1.7.2.2


