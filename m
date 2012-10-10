Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2JJXDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:03:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59008 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757656Ab2JJXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:03 -0400
X-Sasl-enc: Nsp2PktWjqls+nyboK5OVeqlaNEuaM6PV5q4c/SRXt+L 1349910182
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 058/122] ASoC: wm9712: Fix name of Capture Switch
Date: Thu, 11 Oct 2012 07:53:44 +0900
Message-Id: <20121010225348.525330358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,7 +146,7 @@ SOC_SINGLE("Playback Attenuate (-6dB) Sw
 SOC_SINGLE("Bass Volume", AC97_MASTER_TONE, 8, 15, 1),
 SOC_SINGLE("Treble Volume", AC97_MASTER_TONE, 0, 15, 1),
 
-SOC_SINGLE("Capture ADC Switch", AC97_REC_GAIN, 15, 1, 1),
+SOC_SINGLE("Capture Switch", AC97_REC_GAIN, 15, 1, 1),
 SOC_ENUM("Capture Volume Steps", wm9712_enum[6]),
 SOC_DOUBLE("Capture Volume", AC97_REC_GAIN, 8, 0, 63, 0),
 SOC_SINGLE("Capture ZC Switch", AC97_REC_GAIN, 7, 1, 0),


