Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2JSCtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:52689 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200Ab2JSCto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 73/76] ASoC: wm2200: Fix non-inverted OUT2 mute control
Date: Thu, 18 Oct 2012 19:47:37 -0700
Message-Id: <20121019024401.855765077@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit a1b98e12b7f8fad2f0aa3c08a3302bcac7ae1ec7 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1028,7 +1028,7 @@ SOC_DOUBLE_R_TLV("OUT2 Digital Volume",
 		 WM2200_DAC_DIGITAL_VOLUME_2R, WM2200_OUT2L_VOL_SHIFT, 0x9f, 0,
 		 digital_tlv),
 SOC_DOUBLE("OUT2 Switch", WM2200_PDM_1, WM2200_SPK1L_MUTE_SHIFT,
-	   WM2200_SPK1R_MUTE_SHIFT, 1, 0),
+	   WM2200_SPK1R_MUTE_SHIFT, 1, 1),
 };
 
 WM2200_MIXER_ENUMS(OUT1L, WM2200_OUT1LMIX_INPUT_1_SOURCE);


