Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1I1WiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1WiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:25 2011
Message-Id: <20110928220125.881728532@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [006/244] ASoC: ad193x: fix registers definition
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Scott Jiang <scott.jiang.linux@gmail.com>

commit bf545ed72f2eeac664695a8ea2199d9ddaef6020 upstream.

fix dac word len mask and adc tdm fmt shift value

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ad193x.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/ad193x.h
+++ b/sound/soc/codecs/ad193x.h
@@ -34,7 +34,7 @@
 #define AD193X_DAC_LEFT_HIGH    (1 << 3)
 #define AD193X_DAC_BCLK_INV     (1 << 7)
 #define AD193X_DAC_CTRL2        0x804
-#define AD193X_DAC_WORD_LEN_MASK	0xC
+#define AD193X_DAC_WORD_LEN_MASK        0x18
 #define AD193X_DAC_MASTER_MUTE  1
 #define AD193X_DAC_CHNL_MUTE    0x805
 #define AD193X_DACL1_MUTE       0
@@ -63,7 +63,7 @@
 #define AD193X_ADC_CTRL1        0x80f
 #define AD193X_ADC_SERFMT_MASK		0x60
 #define AD193X_ADC_SERFMT_STEREO	(0 << 5)
-#define AD193X_ADC_SERFMT_TDM		(1 << 2)
+#define AD193X_ADC_SERFMT_TDM		(1 << 5)
 #define AD193X_ADC_SERFMT_AUX		(2 << 5)
 #define AD193X_ADC_WORD_LEN_MASK	0x3
 #define AD193X_ADC_CTRL2        0x810


