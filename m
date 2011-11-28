Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1K1Q2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:28:11 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:15607
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab1K1Q2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:28:08 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <drivers@analog.com>, <device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/7] ASoC: AD193X: Make enum items const char * const
Date: Mon, 28 Nov 2011 17:28:08 +0100
Message-ID: <1322497692-27868-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322497692-27868-1-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 7da7e29..665af5c 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -30,7 +30,7 @@ struct ad193x_priv {
 /*
  * AD193X volume/mute/de-emphasis etc. controls
  */
-static const char *ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
+static const char * const ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
 
 static const struct soc_enum ad193x_deemp_enum =
 	SOC_ENUM_SINGLE(AD193X_DAC_CTRL2, 1, 4, ad193x_deemp);
-- 
1.7.7.3


