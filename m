Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0KCRuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:50:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48709 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932195Ab0KCRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:50:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ASoC: Remove register write trace from WM8994
Date: Wed,  3 Nov 2010 13:50:54 -0400
Message-Id: <1288806654-29936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have trace in the ASoC core so we don't need to our own trace in
the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8994.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3f70dee..d81cac5 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1730,8 +1730,6 @@ static int wm8994_write(struct snd_soc_codec *codec, unsigned int reg,
 	if (!wm8994_volatile(reg))
 		wm8994->reg_cache[reg] = value;
 
-	dev_dbg(codec->dev, "0x%x = 0x%x\n", reg, value);
-
 	return wm8994_reg_write(codec->control_data, reg, value);
 }
 
-- 
1.7.1

