Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1FGFDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:03:50 -0400
Received: from smtp-out-002.synserver.de ([212.40.185.2]:1174 "HELO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751952Ab1FGFDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:03:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24556
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: AD1836: Fix build error
Date: Tue,  7 Jun 2011 07:02:59 +0200
Message-Id: <1307422979-14160-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110607115505.71c9a330.sfr@canb.auug.org.au>
References: <20110607115505.71c9a330.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f97d0c6d5f94 ("ASoC: AD1836: Add input gain control for ADC2") contained
a typo in the register name, causing a build error. This patch fixes it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
 sound/soc/codecs/ad1836.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 1e9a801..e3a9493 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -127,7 +127,7 @@ static const struct snd_soc_dapm_route ad183x_dapm_routes[] = {
 static const DECLARE_TLV_DB_SCALE(ad1836_in_tlv, 0, 300, 0);
 
 static const struct snd_kcontrol_new ad1836_controls[] = {
-	SOC_DOUBLE_TLV("ADC2 Capture Volume", AD183X_ADC_CTRL1, 3, 0, 4, 0,
+	SOC_DOUBLE_TLV("ADC2 Capture Volume", AD1836_ADC_CTRL1, 3, 0, 4, 0,
 	    ad1836_in_tlv),
 };
 
-- 
1.7.2.5

