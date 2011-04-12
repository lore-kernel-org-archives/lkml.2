Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1DLOxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:53:51 -0400
Received: from kroah.org ([198.145.64.141]:57532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab1DLOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:51 2011
Message-Id: <20110412143551.795625729@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [036/105] ASoC: Fix CODEC device name for Corgi
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 326b9bdc2a0e4d556a0f444085dca103bcd505de upstream.

Got typoed in the multi-component changes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/corgi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -310,7 +310,7 @@ static struct snd_soc_dai_link corgi_dai
 	.cpu_dai_name = "pxa2xx-i2s",
 	.codec_dai_name = "wm8731-hifi",
 	.platform_name = "pxa-pcm-audio",
-	.codec_name = "wm8731-codec-0.001b",
+	.codec_name = "wm8731-codec.0-001b",
 	.init = corgi_wm8731_init,
 	.ops = &corgi_ops,
 };


