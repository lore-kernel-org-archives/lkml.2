Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946014Ab2CPXhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:37:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946003Ab2CPXhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:37:36 -0400
Message-Id: <20120316233447.389460188@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Denis GNUtoo Carikli <GNUtoo@no-log.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 01/38] ASoC: neo1973: fix neo1973 wm8753 initialization
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>

commit b2ccf065f7b23147ed135a41b01d05a332ca6b7e upstream.

The neo1973 driver had wrong codec name which prevented the "sound card"
from appearing.

Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/samsung/neo1973_wm8753.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -425,7 +425,7 @@ static struct snd_soc_dai_link neo1973_d
 	.platform_name = "samsung-audio",
 	.cpu_dai_name = "s3c24xx-iis",
 	.codec_dai_name = "wm8753-hifi",
-	.codec_name = "wm8753-codec.0-001a",
+	.codec_name = "wm8753.0-001a",
 	.init = neo1973_wm8753_init,
 	.ops = &neo1973_hifi_ops,
 },
@@ -434,7 +434,7 @@ static struct snd_soc_dai_link neo1973_d
 	.stream_name = "Voice",
 	.cpu_dai_name = "dfbmcs320-pcm",
 	.codec_dai_name = "wm8753-voice",
-	.codec_name = "wm8753-codec.0-001a",
+	.codec_name = "wm8753.0-001a",
 	.ops = &neo1973_voice_ops,
 },
 };


