Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2JKIDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:03:49 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:5098
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449Ab2JKIDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:03:44 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: [alsa-devel] [PATCH] ASoC: codecs: da9055: Add support for DSP
 mode of AIF
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Oct 2012 13:44:39 +0530
Message-ID: <1349943279.24126.4.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds AIF DSP mode support for da9055 codec driver.


Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 sound/soc/codecs/da9055.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index 185d8dd..27c4454 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -173,6 +173,7 @@
 #define DA9055_AIF_FORMAT_I2S_MODE	(0 << 0)
 #define DA9055_AIF_FORMAT_LEFT_J	(1 << 0)
 #define DA9055_AIF_FORMAT_RIGHT_J	(2 << 0)
+#define DA9055_AIF_FORMAT_DSP		(3 << 0)
 #define DA9055_AIF_WORD_S16_LE		(0 << 2)
 #define DA9055_AIF_WORD_S20_3LE		(1 << 2)
 #define DA9055_AIF_WORD_S24_LE		(2 << 2)
@@ -1155,6 +1156,9 @@ static int da9055_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	case SND_SOC_DAIFMT_RIGHT_J:
 		aif_ctrl = DA9055_AIF_FORMAT_RIGHT_J;
 		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		aif_ctrl = DA9055_AIF_FORMAT_DSP;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.1


