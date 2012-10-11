Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab2JKCXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:23:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51655 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933972Ab2JKCON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:13 -0400
X-Sasl-enc: 6xH7qDQ74tl8eMNqKcV3VM7V5F17lmm7sKmRCLqAEM36 1349921652
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 50/84] ASoC: wm9712: Fix name of Capture Switch
Date: Thu, 11 Oct 2012 11:03:34 +0900
Message-Id: <20121011015426.056779579@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 689185b78ba6fbe0042f662a468b5565909dff7a upstream.

Help UIs associate it with the matching gain control.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm9712.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -144,7 +144,7 @@ SOC_SINGLE("Playback Attenuate (-6dB) Sw
 SOC_SINGLE("Bass Volume", AC97_MASTER_TONE, 8, 15, 1),
 SOC_SINGLE("Treble Volume", AC97_MASTER_TONE, 0, 15, 1),
 
-SOC_SINGLE("Capture ADC Switch", AC97_REC_GAIN, 15, 1, 1),
+SOC_SINGLE("Capture Switch", AC97_REC_GAIN, 15, 1, 1),
 SOC_ENUM("Capture Volume Steps", wm9712_enum[6]),
 SOC_DOUBLE("Capture Volume", AC97_REC_GAIN, 8, 0, 63, 1),
 SOC_SINGLE("Capture ZC Switch", AC97_REC_GAIN, 7, 1, 0),


