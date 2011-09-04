Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1IDOsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 10:48:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36627 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1IDOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 10:48:38 -0400
Subject: [PATCH] ASoC: alc5623: Remove unused mutex
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Sep 2011 22:48:27 +0800
Message-ID: <1315147707.2662.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
---
 sound/soc/codecs/alc5623.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index eecffb5..0517315 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -41,7 +41,6 @@ MODULE_PARM_DESC(caps_charge, "ALC5623 cap charge time (msecs)");
 struct alc5623_priv {
 	enum snd_soc_control_type control_type;
 	void *control_data;
-	struct mutex mutex;
 	u8 id;
 	unsigned int sysclk;
 	u16 reg_cache[ALC5623_VENDOR_ID2+2];
@@ -1052,7 +1051,6 @@ static int alc5623_i2c_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, alc5623);
 	alc5623->control_data = client;
 	alc5623->control_type = SND_SOC_I2C;
-	mutex_init(&alc5623->mutex);
 
 	ret =  snd_soc_register_codec(&client->dev,
 		&soc_codec_device_alc5623, &alc5623_dai, 1);
-- 
1.7.4.1



