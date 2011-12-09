Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1LINQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:16:40 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:63378 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1LINQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:16:39 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] ASoC: Fix an obvious copy paste error in an error message
Date: Fri,  9 Dec 2011 14:16:29 +0100
Message-Id: <1323436589-28168-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message was obviously copied from soc_init_codec_debugfs()

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/soc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a5d3685..9548881 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -412,7 +412,7 @@ static void soc_init_card_debugfs(struct snd_soc_card *card)
 						     snd_soc_debugfs_root);
 	if (!card->debugfs_card_root) {
 		dev_warn(card->dev,
-			 "ASoC: Failed to create codec debugfs directory\n");
+			 "ASoC: Failed to create card debugfs directory\n");
 		return;
 	}
 
-- 
1.5.6.5

