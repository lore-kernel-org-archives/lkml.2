Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1JDDpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 23:45:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61861 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1JDDps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 23:45:48 -0400
Subject: [PATCH 2/2] ASoC: Remove unneeded hw_write initialisation in wm8523
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317699882.19150.0.camel@phoenix>
References: <1317699882.19150.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 11:45:41 +0800
Message-ID: <1317699941.19150.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not required after commit 8d50e447
"ASoC: Factor out I/O for Wolfson 8 bit data 16 bit register CODECs"

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8523.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index 5355a7a..db7a681 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -406,7 +406,6 @@ static int wm8523_probe(struct snd_soc_codec *codec)
 	struct wm8523_priv *wm8523 = snd_soc_codec_get_drvdata(codec);
 	int ret, i;
 
-	codec->hw_write = (hw_write_t)i2c_master_send;
 	wm8523->rate_constraint.list = &wm8523->rate_constraint_list[0];
 	wm8523->rate_constraint.count =
 		ARRAY_SIZE(wm8523->rate_constraint_list);
-- 
1.7.4.1



