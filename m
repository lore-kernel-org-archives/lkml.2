Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1LINiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:38:20 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64833 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1LINiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:38:18 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/5] ASoC: mxs: General cleanups
Date: Fri,  9 Dec 2011 14:38:08 +0100
Message-Id: <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some textual cleanups without functional changes

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/codecs/sgtl5000.c |   13 ++++++-------
 sound/soc/mxs/mxs-saif.c    |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index bbcf921..fd0489b 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -73,7 +73,7 @@ enum sgtl5000_regulator_supplies {
 static const char *supply_names[SGTL5000_SUPPLY_NUM] = {
 	"VDDA",
 	"VDDIO",
-	"VDDD"
+	"VDDD",
 };
 
 #define LDO_CONSUMER_NAME	"VDDD_LDO"
@@ -1278,7 +1278,6 @@ err_regulator_free:
 	if (external_vddd)
 		ldo_regulator_remove(codec);
 	return ret;
-
 }
 
 static int sgtl5000_probe(struct snd_soc_codec *codec)
@@ -1431,7 +1430,7 @@ static __devexit int sgtl5000_i2c_remove(struct i2c_client *client)
 
 static const struct i2c_device_id sgtl5000_id[] = {
 	{"sgtl5000", 0},
-	{},
+	{ /* sentinel */ }
 };
 
 MODULE_DEVICE_TABLE(i2c, sgtl5000_id);
@@ -1444,10 +1443,10 @@ MODULE_DEVICE_TABLE(of, sgtl5000_dt_ids);
 
 static struct i2c_driver sgtl5000_i2c_driver = {
 	.driver = {
-		   .name = "sgtl5000",
-		   .owner = THIS_MODULE,
-		   .of_match_table = sgtl5000_dt_ids,
-		   },
+		.name = "sgtl5000",
+		.owner = THIS_MODULE,
+		.of_match_table = sgtl5000_dt_ids,
+	},
 	.probe = sgtl5000_i2c_probe,
 	.remove = __devexit_p(sgtl5000_i2c_remove),
 	.id_table = sgtl5000_id,
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 76dc74d..487d2ff 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -481,7 +481,7 @@ static int mxs_saif_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		/*
 		 * If the saif's master is not himself, we also need to enable
-		 * itself clk for its internal basic logic to work.
+		 * its clk for its internal basic logic to work.
 		 */
 		if (saif != master_saif) {
 			clk_enable(saif->clk);
-- 
1.5.6.5

