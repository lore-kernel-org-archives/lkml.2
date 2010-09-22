Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0IVTfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:35:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54207 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0IVTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:35:03 -0400
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] Fix typo configue => configure in comments
Date: Wed, 22 Sep 2010 21:36:08 +0200
Message-Id: <1285184168-28305-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/mips/pci/fixup-fuloong2e.c          |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c  |    2 +-
 net/irda/irnet/irnet_ppp.c               |    2 +-
 sound/soc/s3c24xx/neo1973_gta02_wm8753.c |    2 +-
 sound/soc/s3c24xx/neo1973_wm8753.c       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/pci/fixup-fuloong2e.c b/arch/mips/pci/fixup-fuloong2e.c
index 4f6d8da..d5d4c01 100644
--- a/arch/mips/pci/fixup-fuloong2e.c
+++ b/arch/mips/pci/fixup-fuloong2e.c
@@ -52,7 +52,7 @@ static void __init loongson2e_nec_fixup(struct pci_dev *pdev)
 {
 	unsigned int val;
 
-	/* Configues port 1, 2, 3, 4 to be validate*/
+	/* Configures port 1, 2, 3, 4 to be validate*/
 	pci_read_config_dword(pdev, 0xe0, &val);
 	pci_write_config_dword(pdev, 0xe0, (val & ~7) | 0x4);
 
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index e9d9d62..b7cb165 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2621,7 +2621,7 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	/* Detect early interrupt before driver is fully configued */
+	/* Detect early interrupt before driver is fully configured */
 	spin_lock(&local->irq_init_lock);
 	if (!dev->base_addr) {
 		if (net_ratelimit()) {
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index dfe7b38..36f43ca 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -663,7 +663,7 @@ dev_irnet_ioctl(
       if((val == N_SYNC_PPP) || (val == N_PPP))
 	{
 	  DEBUG(FS_INFO, "Entering PPP discipline.\n");
-	  /* PPP channel setup (ap->chan in configued in dev_irnet_open())*/
+	  /* PPP channel setup (ap->chan in configured in dev_irnet_open())*/
 	  lock_kernel();
 	  err = ppp_register_channel(&ap->chan);
 	  if(err == 0)
diff --git a/sound/soc/s3c24xx/neo1973_gta02_wm8753.c b/sound/soc/s3c24xx/neo1973_gta02_wm8753.c
index 209c259..4719558 100644
--- a/sound/soc/s3c24xx/neo1973_gta02_wm8753.c
+++ b/sound/soc/s3c24xx/neo1973_gta02_wm8753.c
@@ -182,7 +182,7 @@ static int neo1973_gta02_voice_hw_params(
 	if (ret < 0)
 		return ret;
 
-	/* configue and enable PLL for 12.288MHz output */
+	/* configure and enable PLL for 12.288MHz output */
 	ret = snd_soc_dai_set_pll(codec_dai, WM8753_PLL2, 0,
 		iis_clkrate / 4, 12288000);
 	if (ret < 0)
diff --git a/sound/soc/s3c24xx/neo1973_wm8753.c b/sound/soc/s3c24xx/neo1973_wm8753.c
index 0cb4f86..4ac6209 100644
--- a/sound/soc/s3c24xx/neo1973_wm8753.c
+++ b/sound/soc/s3c24xx/neo1973_wm8753.c
@@ -201,7 +201,7 @@ static int neo1973_voice_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 
-	/* configue and enable PLL for 12.288MHz output */
+	/* configure and enable PLL for 12.288MHz output */
 	ret = snd_soc_dai_set_pll(codec_dai, WM8753_PLL2, 0,
 		iis_clkrate / 4, 12288000);
 	if (ret < 0)
-- 
1.7.3

