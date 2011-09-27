Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1I0CiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:38:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53276 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1I0CiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:38:19 -0400
Subject: [PATCH 1/2] ASoC: Remove unused fields in struct mfld_mc_private
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Harsha Priya <priya.harsha@intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:38:07 +0800
Message-ID: <1317091087.315.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both *socdev and *codec of struct mfld_mc_private are not being used
in this driver, remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/mid-x86/mfld_machine.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index 429aa1b..1d818dc 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -54,9 +54,7 @@ static unsigned int	hs_switch;
 static unsigned int	lo_dac;
 
 struct mfld_mc_private {
-	struct platform_device *socdev;
 	void __iomem *int_base;
-	struct snd_soc_codec *codec;
 	u8 interrupt_status;
 };
 
-- 
1.7.4.1



