Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1HPCvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1HPCvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:00 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:54 2011
Message-Id: <20110816024454.697255272@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [17/26] ASoC: Fix binding of WM8750 on Jive
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 6678050442e90a4e9511a9ed14b9bdfc5e393323 upstream.

The I2C address is misformatted and would never match.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/samsung/jive_wm8750.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/samsung/jive_wm8750.c
+++ b/sound/soc/samsung/jive_wm8750.c
@@ -131,7 +131,7 @@ static struct snd_soc_dai_link jive_dai
 	.cpu_dai_name	= "s3c2412-i2s",
 	.codec_dai_name = "wm8750-hifi",
 	.platform_name	= "samsung-audio",
-	.codec_name	= "wm8750-codec.0-0x1a",
+	.codec_name	= "wm8750-codec.0-001a",
 	.init		= jive_wm8750_init,
 	.ops		= &jive_ops,
 };


