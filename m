Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1BPBZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:25:19 -0500
Received: from kroah.org ([198.145.64.141]:49172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab1BPAWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.472718888@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [154/272] ASoC: da8xx/omap-l1xx: match codec_name with i2c ids
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

commit dc5a460a1bfa44273653700e33d4e7051194cbfd upstream.

The codec_name entry for da8xx evm in sound/soc/davinci/davinci-evm.c
is not matching with the i2c ids in the board file. Without this fix the
soundcard does not get detected on da850/omap-l138/am18x evm.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Tested-by: Dan Sharon <dansharon@nanometrics.ca>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/davinci/davinci-evm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -224,7 +224,7 @@ static struct snd_soc_dai_link da8xx_evm
 	.stream_name = "AIC3X",
 	.cpu_dai_name= "davinci-mcasp.0",
 	.codec_dai_name = "tlv320aic3x-hifi",
-	.codec_name = "tlv320aic3x-codec.0-001a",
+	.codec_name = "tlv320aic3x-codec.1-0018",
 	.platform_name = "davinci-pcm-audio",
 	.init = evm_aic3x_init,
 	.ops = &evm_ops,


