Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1JDDo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 23:44:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62331 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1JDDo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 23:44:58 -0400
Subject: [PATCH 1/2] ASoC: Remove unneeded hw_write initialisation in ak4671
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 11:44:42 +0800
Message-ID: <1317699882.19150.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not required now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4671.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index 2ecf128..41e3d55 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -628,8 +628,6 @@ static int ak4671_probe(struct snd_soc_codec *codec)
 	struct ak4671_priv *ak4671 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->hw_write = (hw_write_t)i2c_master_send;
-
 	ret = snd_soc_codec_set_cache_io(codec, 8, 8, ak4671->control_type);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-- 
1.7.4.1



