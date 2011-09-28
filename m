Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1I1XRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:17:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab1I1WnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.255280175@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [113/244] ASoC: Blackfin: bf5xx-ad193x: Fix codec device name
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit c5d2e650bd805a00ff9af537d5b5dede598a198c upstream.

Fix the codec_name field of the dai_link to match the actual device name
of the codec. Otherwise the card won't be instantiated.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/blackfin/bf5xx-ad193x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/blackfin/bf5xx-ad193x.c
+++ b/sound/soc/blackfin/bf5xx-ad193x.c
@@ -103,7 +103,7 @@ static struct snd_soc_dai_link bf5xx_ad1
 		.cpu_dai_name = "bfin-tdm.0",
 		.codec_dai_name ="ad193x-hifi",
 		.platform_name = "bfin-tdm-pcm-audio",
-		.codec_name = "ad193x.5",
+		.codec_name = "spi0.5",
 		.ops = &bf5xx_ad193x_ops,
 	},
 	{
@@ -112,7 +112,7 @@ static struct snd_soc_dai_link bf5xx_ad1
 		.cpu_dai_name = "bfin-tdm.1",
 		.codec_dai_name ="ad193x-hifi",
 		.platform_name = "bfin-tdm-pcm-audio",
-		.codec_name = "ad193x.5",
+		.codec_name = "spi0.5",
 		.ops = &bf5xx_ad193x_ops,
 	},
 };


