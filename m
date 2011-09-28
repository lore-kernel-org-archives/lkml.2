Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1I1Fsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:48:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61218 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1I1Fsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:48:42 -0400
Subject: [PATCH 2/2] ASoC: adau1701: Fix prototype for adau1701_set_sysclk
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cliff Cai <cliff.cai@analog.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317188861.13692.1.camel@phoenix>
References: <1317188861.13692.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 13:48:35 +0800
Message-ID: <1317188915.13692.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/adau1701.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index 1354902..d2e1237 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -402,7 +402,7 @@ static int adau1701_digital_mute(struct snd_soc_dai *dai, int mute)
 }
 
 static int adau1701_set_sysclk(struct snd_soc_codec *codec, int clk_id,
-	unsigned int freq, int dir)
+	int source, unsigned int freq, int dir)
 {
 	unsigned int val;
 
-- 
1.7.4.1



