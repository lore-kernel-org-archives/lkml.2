Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab1JEGk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:40:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45552 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab1JEGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:40:57 -0400
Subject: [PATCH 1/2] ASoC: Remove unused function declaration in imx-ssi.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 14:40:46 +0800
Message-ID: <1317796846.21481.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are removed in commit f0fba2ad
"ASoC: multi-component - ASoC Multi-Component Support".
Let's remove the leftover function declaration in header file.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/imx/imx-ssi.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/sound/soc/imx/imx-ssi.h b/sound/soc/imx/imx-ssi.h
index 0a84cec..1072dfb 100644
--- a/sound/soc/imx/imx-ssi.h
+++ b/sound/soc/imx/imx-ssi.h
@@ -218,12 +218,6 @@ struct imx_ssi {
 	struct platform_device *soc_platform_pdev_fiq;
 };
 
-struct snd_soc_platform *imx_ssi_fiq_init(struct platform_device *pdev,
-		struct imx_ssi *ssi);
-void imx_ssi_fiq_exit(struct platform_device *pdev, struct imx_ssi *ssi);
-struct snd_soc_platform *imx_ssi_dma_mx2_init(struct platform_device *pdev,
-		struct imx_ssi *ssi);
-
 int snd_imx_pcm_mmap(struct snd_pcm_substream *substream, struct vm_area_struct *vma);
 int imx_pcm_new(struct snd_soc_pcm_runtime *rtd);
 void imx_pcm_free(struct snd_pcm *pcm);
-- 
1.7.4.1



