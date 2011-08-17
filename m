Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1HQHOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:14:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41171 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1HQHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:14:41 -0400
Subject: [PATCH] ASoC: Remove unreachable code in au1xac97c_drvprobe and
 au1xi2s_drvprobe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 15:14:33 +0800
Message-ID: <1313565273.30708.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/au1x/ac97c.c |    2 --
 sound/soc/au1x/i2sc.c  |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/au1x/ac97c.c b/sound/soc/au1x/ac97c.c
index 9c05f38..13802ff 100644
--- a/sound/soc/au1x/ac97c.c
+++ b/sound/soc/au1x/ac97c.c
@@ -275,8 +275,6 @@ static int __devinit au1xac97c_drvprobe(struct platform_device *pdev)
 	ac97c_workdata = ctx;
 	return 0;
 
-
-	snd_soc_unregister_dai(&pdev->dev);
 out1:
 	release_mem_region(r->start, resource_size(r));
 out0:
diff --git a/sound/soc/au1x/i2sc.c b/sound/soc/au1x/i2sc.c
index b4172fd..19e0d2a 100644
--- a/sound/soc/au1x/i2sc.c
+++ b/sound/soc/au1x/i2sc.c
@@ -267,7 +267,6 @@ static int __devinit au1xi2s_drvprobe(struct platform_device *pdev)
 
 	return 0;
 
-	snd_soc_unregister_dai(&pdev->dev);
 out1:
 	release_mem_region(r->start, resource_size(r));
 out0:
-- 
1.7.4.1



