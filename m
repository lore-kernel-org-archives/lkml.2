Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1HMDpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 23:45:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56274 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1HMDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 23:45:20 -0400
Subject: [PATCH] ASoC: wm8750: Fix missing braces around initializer warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <richard@openedhand.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:45:14 +0800
Message-ID: <1313207114.29596.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below warning:
  CC      sound/soc/codecs/wm8750.o
sound/soc/codecs/wm8750.c:784: warning: missing braces around initializer
sound/soc/codecs/wm8750.c:784: warning: (near initialization for 'wm8750_spi_ids[2].name')

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8750.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 82ac5fc..8983ab1 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -781,7 +781,7 @@ static int __devexit wm8750_spi_remove(struct spi_device *spi)
 static const struct spi_device_id wm8750_spi_ids[] = {
 	{ "wm8750", 0 },
 	{ "wm8987", 0 },
-	{ 0, 0 },
+	{ }
 };
 MODULE_DEVICE_TABLE(spi, wm8750_spi_ids);
 
-- 
1.7.4.1



