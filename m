Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2BHLyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:54:03 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50347
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756372Ab2BHLyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:54:01 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: peter.ujfalusi@ti.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] twl4030: Fix typo in twl4030.c
Date: Wed,  8 Feb 2012 20:53:34 +0900
Message-Id: <1328702014-1956-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "memroy" to "memory" in
sound/soc/codecs/twl4030.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/codecs/twl4030.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 3039ba2..d7eee0d 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -2221,7 +2221,7 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 
 	twl4030 = kzalloc(sizeof(struct twl4030_priv), GFP_KERNEL);
 	if (twl4030 == NULL) {
-		printk("Can not allocate memroy\n");
+		printk("Can not allocate memory\n");
 		return -ENOMEM;
 	}
 	snd_soc_codec_set_drvdata(codec, twl4030);
-- 
1.7.6.5

