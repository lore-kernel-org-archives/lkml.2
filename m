Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2JJXI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:08:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43108 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932606Ab2JJXDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:14 -0400
X-Sasl-enc: PR3JDGjtNUWu1F2To7Bwc7qsKA5NY6ZWTgJ2kDkrZIvL 1349910193
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 057/122] ASoC: wm5110: Adding missing volume update bits
Date: Thu, 11 Oct 2012 07:53:43 +0900
Message-Id: <20121010225348.342934193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit ae60503741991a36ed6b2a8f53b249b2a72af52b upstream.

The volume update bits were being set on all but one input and one output.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5110.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -869,6 +869,8 @@ static unsigned int wm5110_digital_vu[]
 	ARIZONA_ADC_DIGITAL_VOLUME_2R,
 	ARIZONA_ADC_DIGITAL_VOLUME_3L,
 	ARIZONA_ADC_DIGITAL_VOLUME_3R,
+	ARIZONA_ADC_DIGITAL_VOLUME_4L,
+	ARIZONA_ADC_DIGITAL_VOLUME_4R,
 
 	ARIZONA_DAC_DIGITAL_VOLUME_1L,
 	ARIZONA_DAC_DIGITAL_VOLUME_1R,
@@ -880,6 +882,8 @@ static unsigned int wm5110_digital_vu[]
 	ARIZONA_DAC_DIGITAL_VOLUME_4R,
 	ARIZONA_DAC_DIGITAL_VOLUME_5L,
 	ARIZONA_DAC_DIGITAL_VOLUME_5R,
+	ARIZONA_DAC_DIGITAL_VOLUME_6L,
+	ARIZONA_DAC_DIGITAL_VOLUME_6R,
 };
 
 static struct snd_soc_codec_driver soc_codec_dev_wm5110 = {


