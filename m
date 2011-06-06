Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1FFAsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:48:00 -0400
Received: from mta31.charter.net ([216.33.127.82]:56409 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1FFAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:47:58 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=TIXtVO2YP3oA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=SNreROneYDogju07Rr8A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: perex@perex.cz, tiwai@suse.de
Cc: broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@ti.com, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] wm8940: remove unecessary if statement
Date: Sun,  5 Jun 2011 19:47:54 -0500
Message-Id: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code always returns ret regardless, so if(ret) check is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 sound/soc/codecs/wm8940.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 25580e3..1ada6d3 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -730,9 +730,6 @@ static int wm8940_probe(struct snd_soc_codec *codec)
 	if (ret)
 		return ret;
 	ret = wm8940_add_widgets(codec);
-	if (ret)
-		return ret;
-
 	return ret;
 }
 
-- 
1.7.2.5

