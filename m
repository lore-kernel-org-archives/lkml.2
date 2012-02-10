Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab2BJXLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:11:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab2BJWmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:42 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.358830765@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 60/86] ASoC: wm8994: Fix typo in VMID ramp setting
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit f647e1526fd6c7c8ab720781c40d11e11f930e93 upstream.

The VMID ramp rate is supposed to be 0x3, not 11b. Fix that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -744,7 +744,7 @@ static void vmid_reference(struct snd_so
 				    WM8994_VMID_RAMP_MASK,
 				    WM8994_STARTUP_BIAS_ENA |
 				    WM8994_VMID_BUF_ENA |
-				    (0x11 << WM8994_VMID_RAMP_SHIFT));
+				    (0x3 << WM8994_VMID_RAMP_SHIFT));
 
 		/* Main bias enable, VMID=2x40k */
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_1,


