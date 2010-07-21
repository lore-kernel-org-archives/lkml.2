Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0GUMfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:35:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58243 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab0GUMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:35:43 -0400
Date: Wed, 21 Jul 2010 14:35:41 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/3] sound/soc/atmel: Remove dead
 CONFIG_AT32_ENHANCED_PORTMUX
Message-ID: <d2382c03db1d5b41a857b67688bf32838993d137.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_AT32_ENCHANCED_PORTMUX doesn't exist in Kconfig or somewhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 sound/soc/atmel/playpaq_wm8510.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/sound/soc/atmel/playpaq_wm8510.c b/sound/soc/atmel/playpaq_wm8510.c
index 9df4c68..fbd17e9 100644
--- a/sound/soc/atmel/playpaq_wm8510.c
+++ b/sound/soc/atmel/playpaq_wm8510.c
@@ -425,11 +425,6 @@ static int __init playpaq_asoc_init(void)
 	clk_set_rate(CODEC_CLK, 12000000);
 	clk_enable(CODEC_CLK);
 
-#if defined CONFIG_AT32_ENHANCED_PORTMUX
-	at32_select_periph(MCLK_PIN, MCLK_PERIPH, 0);
-#endif
-
-
 	/*
 	 * Create and register platform device
 	 */
@@ -496,10 +491,6 @@ static void __exit playpaq_asoc_exit(void)
 		_pll0 = NULL;
 	}
 
-#if defined CONFIG_AT32_ENHANCED_PORTMUX
-	at32_free_pin(MCLK_PIN);
-#endif
-
 	platform_device_unregister(playpaq_snd_device);
 	playpaq_snd_device = NULL;
 }
-- 
1.7.0.4

