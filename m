Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1JTCuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:50:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43006 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1JTCuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:50:15 -0400
Message-ID: <1319079003.5380.1.camel@phoenix>
Subject: [PATCH] ASoC: Fix reg_word_size for ak4104
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 10:50:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the register map in datasheet, the registers are 8 bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4104.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ak4104.c b/sound/soc/codecs/ak4104.c
index cbf0b6d..d3b29dc 100644
--- a/sound/soc/codecs/ak4104.c
+++ b/sound/soc/codecs/ak4104.c
@@ -247,7 +247,7 @@ static struct snd_soc_codec_driver soc_codec_device_ak4104 = {
 	.probe =	ak4104_probe,
 	.remove =	ak4104_remove,
 	.reg_cache_size = AK4104_NUM_REGS,
-	.reg_word_size = sizeof(u16),
+	.reg_word_size = sizeof(u8),
 };
 
 static int ak4104_spi_probe(struct spi_device *spi)
-- 
1.7.5.4



