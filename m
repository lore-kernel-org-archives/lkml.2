Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1LLJoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:44:17 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:59351 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:44:16 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v2] Export symbols 'mxs_saif_put_mclk()' and 'mxs_saif_get_mclk()'
Date: Mon, 12 Dec 2011 10:44:04 +0100
Message-Id: <1323683044-11694-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following errors with MXS sound support built as module:
|ERROR: "mxs_saif_put_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undefined!
|ERROR: "mxs_saif_get_mclk" [sound/soc/mxs/snd-soc-mxs-sgtl5000.ko] undefined!

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/mxs/mxs-saif.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 487d2ff..ec66a29 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -221,6 +221,7 @@ int mxs_saif_put_mclk(unsigned int saif_id)
 	saif->mclk_in_use = 0;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mxs_saif_put_mclk);
 
 /*
  * Get MCLK and set clock rate, then enable it
@@ -274,7 +275,7 @@ int mxs_saif_get_mclk(unsigned int saif_id, unsigned int mclk,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mxs_saif_get_mclk);
 
 /*
  * SAIF DAI format configuration.
-- 
1.5.6.5

