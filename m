Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958Ab1KJDsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934796Ab1KJDs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.641686148@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hong Xu <hong.xu@atmel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [220/264] ASoC: WM8904: Set `invert bit for Capture Switch
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Xu <hong.xu@atmel.com>

commit 5a7c5f26df3c0122814dfa1c13ef6dfbdbffdb86 upstream.

Set `invert' bit for Capture Switch. Otherwise analogue is muted when
Capture Switch is ON.

Signed-off-by: Hong Xu <hong.xu@atmel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8904.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -868,7 +868,7 @@ SOC_ENUM("Right Capture Mode", rin_mode)
 SOC_DOUBLE_R("Capture Volume", WM8904_ANALOGUE_LEFT_INPUT_0,
 	     WM8904_ANALOGUE_RIGHT_INPUT_0, 0, 31, 0),
 SOC_DOUBLE_R("Capture Switch", WM8904_ANALOGUE_LEFT_INPUT_0,
-	     WM8904_ANALOGUE_RIGHT_INPUT_0, 7, 1, 0),
+	     WM8904_ANALOGUE_RIGHT_INPUT_0, 7, 1, 1),
 
 SOC_SINGLE("High Pass Filter Switch", WM8904_ADC_DIGITAL_0, 4, 1, 0),
 SOC_ENUM("High Pass Filter Mode", hpf_mode),


