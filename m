Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2HJGQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:16:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2HJGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:16:37 -0400
From: Jerry Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de
Subject: [PATCH] ASoC: core: remove unused variable in soc_probe() in linux-next
Date: Thu,  9 Aug 2012 23:16:26 -0700
Message-Id: <1344579386-27193-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.12.rc1.17.g9a7365c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 28d528c8 "ASoC: core: Remove pointless error on card
registration failure", the variable ret is no longer used in
soc_probe() and generates an unused variable warning during a build.

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 sound/soc/soc-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 2d98ffc..7adf115 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1816,7 +1816,6 @@ base_error:
 static int soc_probe(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	int ret = 0;
 
 	/*
 	 * no card, so machine driver should be registering card
-- 
1.7.12.rc1.17.g9a7365c

