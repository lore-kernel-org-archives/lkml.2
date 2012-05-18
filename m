Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030934Ab2ERC6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:58:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030727Ab2ERCwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:49 -0400
Message-Id: <20120518023300.176121785@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 43/53] ASoC: wm8994: Fix AIF2ADC power down
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c7f5f2389377b66028bc129890aa653deafe8d39 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 6c1fe3a..2de12eb 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1144,7 +1144,7 @@ static int aif2clk_ev(struct snd_soc_dapm_widget *w,
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
 				    WM8994_AIF2DACL_ENA |
 				    WM8994_AIF2DACR_ENA, 0);
-		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
 				    WM8994_AIF2ADCL_ENA |
 				    WM8994_AIF2ADCR_ENA, 0);
 
-- 
1.7.10



