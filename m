Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946206Ab2I1VQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:16:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36326 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758895Ab2I1Ujp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:45 -0400
X-Sasl-enc: G+fOIKHbYHVAQ991dNy/5xy+GYIDJ0bybCdMrxGh+f5i 1348864784
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 213/218] ASoC: wm2000: Correct register size
Date: Fri, 28 Sep 2012 13:17:10 -0700
Message-Id: <20120928201526.038861242@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit d0e12f3ff3472cbd8f52d3c0e6ee07a841787c40 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -692,7 +692,7 @@ static int wm2000_resume(struct snd_soc_
 #endif
 
 static const struct regmap_config wm2000_regmap = {
-	.reg_bits = 8,
+	.reg_bits = 16,
 	.val_bits = 8,
 };
 


