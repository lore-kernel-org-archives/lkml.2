Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1IODFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:05:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62309 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IODFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:05:03 -0400
Subject: [PATCH] ASoC: bf5xx-ad73311: Fix prototype for bf5xx_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cliff Cai <Cliff.Cai@analog.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:04:56 +0800
Message-ID: <1316055896.3496.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:
sound/soc/blackfin/bf5xx-ad73311.c: warning: initialization from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/blackfin/bf5xx-ad73311.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ad73311.c b/sound/soc/blackfin/bf5xx-ad73311.c
index 732a247..b94eb7e 100644
--- a/sound/soc/blackfin/bf5xx-ad73311.c
+++ b/sound/soc/blackfin/bf5xx-ad73311.c
@@ -128,7 +128,7 @@ static int snd_ad73311_configure(void)
 	return 0;
 }
 
-static int bf5xx_probe(struct platform_device *pdev)
+static int bf5xx_probe(struct snd_soc_card *card)
 {
 	int err;
 	if (gpio_request(GPIO_SE, "AD73311_SE")) {
-- 
1.7.4.1



