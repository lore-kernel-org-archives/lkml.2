Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1JLOnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:43:22 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:4771
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab1JLOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:43:21 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 00/09] ASoC: da7210: Add support for all IOs
 and other features
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:24:06 +0530
Message-ID: <1318431246.12107.393.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  Existing da7210 driver is very minimalistic in terms of functionality.
It supports only one output i.e. head phone. da7210 codec hardware
supports many more IOs and features.

Here is a patch series that is "feature update" in nature. This adds
support for all inputs(MIC L-R, AUX1 L-R, AUX2) and outputs (OUT1 L-R,
OUT2) as well as following features,

- ADC and DAC equalizers
- Mute
- Zero cross
- Other DAI word lengths, format and mode
- ALC
- Noise suppression
- High pass and voice filters
- DAPM

This series also contains a small bug fix for head phone volume control.

Thanks,

-- Ashish (GNU FAN)

---
Ashish Chavan (9):
      ASoC: da7210: Add support for line out and DAC
      ASoC: da7210: Add support for line input and mic
      ASoC: da7210: Add support for ADC & DAC equalizers
      ASoC: da7210: Add support for mute and zero cross controls
      ASoC: da7210: Add support for other DAI length, format and mode
      ASoC: da7210: bugfix for head phone volume control
      ASoC: da7210: Add support for ALC and Noise suppression
      ASoC: da7210: Add support for High pass and Voice filters
      ASoC: da7210: Add support for DAPM

 sound/soc/codecs/da7210.c |  642 +++++++++++++++++++++++++++++++++++---
 1 files changed, 586 insertions(+), 56 deletions(-)

-- 
1.7.1


