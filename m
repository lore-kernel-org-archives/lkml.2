Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0HXW6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:04 -0400
Received: from kroah.org ([198.145.64.141]:52400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab0HXW56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:57:58 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.323274331@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [03/91] ASoC: Fix inverted mute controls for WM8580
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 4f0ed9a51bc8ef16c2589112fdb110479e4b0df1 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8580.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -269,9 +269,9 @@ SOC_DOUBLE("DAC2 Invert Switch", WM8580_
 SOC_DOUBLE("DAC3 Invert Switch", WM8580_DAC_CONTROL4,  4, 5, 1, 0),
 
 SOC_SINGLE("DAC ZC Switch", WM8580_DAC_CONTROL5, 5, 1, 0),
-SOC_SINGLE("DAC1 Switch", WM8580_DAC_CONTROL5, 0, 1, 0),
-SOC_SINGLE("DAC2 Switch", WM8580_DAC_CONTROL5, 1, 1, 0),
-SOC_SINGLE("DAC3 Switch", WM8580_DAC_CONTROL5, 2, 1, 0),
+SOC_SINGLE("DAC1 Switch", WM8580_DAC_CONTROL5, 0, 1, 1),
+SOC_SINGLE("DAC2 Switch", WM8580_DAC_CONTROL5, 1, 1, 1),
+SOC_SINGLE("DAC3 Switch", WM8580_DAC_CONTROL5, 2, 1, 1),
 
 SOC_DOUBLE("ADC Mute Switch", WM8580_ADC_CONTROL1, 0, 1, 1, 0),
 SOC_SINGLE("ADC High-Pass Filter Switch", WM8580_ADC_CONTROL1, 4, 1, 0),


