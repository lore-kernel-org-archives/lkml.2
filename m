Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946639Ab2ERXGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:06:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946625Ab2ERXGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:06 -0400
Message-Id: <20120518212650.561740440@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 15/47] ASoC: wm8994: Fix AIF2ADC power down
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c7f5f2389377b66028bc129890aa653deafe8d39 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1073,7 +1073,7 @@ static int aif2clk_ev(struct snd_soc_dap
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
 				    WM8994_AIF2DACL_ENA |
 				    WM8994_AIF2DACR_ENA, 0);
-		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
 				    WM8994_AIF2ADCL_ENA |
 				    WM8994_AIF2ADCR_ENA, 0);
 


