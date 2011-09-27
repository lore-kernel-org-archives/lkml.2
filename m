Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1I0Ci7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:38:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1I0Ci5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:38:57 -0400
Subject: [PATCH 2/2] ASoC: Staticise sst_platform_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Harsha Priya <priya.harsha@intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317091087.315.1.camel@phoenix>
References: <1317091087.315.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:38:50 +0800
Message-ID: <1317091130.315.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/mid-x86/sst_platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/mid-x86/sst_platform.c b/sound/soc/mid-x86/sst_platform.c
index 9925d20..7df8c58 100644
--- a/sound/soc/mid-x86/sst_platform.c
+++ b/sound/soc/mid-x86/sst_platform.c
@@ -63,7 +63,7 @@ static struct snd_pcm_hardware sst_platform_pcm_hw = {
 };
 
 /* MFLD - MSIC */
-struct snd_soc_dai_driver sst_platform_dai[] = {
+static struct snd_soc_dai_driver sst_platform_dai[] = {
 {
 	.name = "Headset-cpu-dai",
 	.id = 0,
-- 
1.7.4.1



