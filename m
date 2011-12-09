Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1LINiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:38:19 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64832 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1LINiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:38:18 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/5] ASoC: mxs: Export symbols 'mxs_saif_put_mclk()' and 'mxs_saif_get_mclk()'
Date: Fri,  9 Dec 2011 14:38:10 +0100
Message-Id: <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
 <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
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
+EXPORT_SYMBOL(mxs_saif_put_mclk);
 
 /*
  * Get MCLK and set clock rate, then enable it
@@ -274,6 +275,7 @@ int mxs_saif_get_mclk(unsigned int saif_id, unsigned int mclk,
 
 	return 0;
 }
+EXPORT_SYMBOL(mxs_saif_get_mclk);
 
 /*
  * SAIF DAI format configuration.
-- 
1.5.6.5

