Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668Ab1CEBKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:10:16 -0500
Received: from kroah.org ([198.145.64.141]:50387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760236Ab1CEBAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.501593129@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [50/73] eukrea-tlv320: fix platform_name
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Bénard <eric@eukrea.com>

commit 43c63188821dc21b2af23a40a18faea6e386e90a upstream.

commit f0fba2ad1b6b53d5360125c41953b7afcd6deff0 included a mistake
on the name of the platform in the snd_soc_dai_link structure.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/imx/eukrea-tlv320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/imx/eukrea-tlv320.c
+++ b/sound/soc/imx/eukrea-tlv320.c
@@ -80,7 +80,7 @@ static struct snd_soc_dai_link eukrea_tl
 	.name		= "tlv320aic23",
 	.stream_name	= "TLV320AIC23",
 	.codec_dai_name	= "tlv320aic23-hifi",
-	.platform_name	= "imx-pcm-audio.0",
+	.platform_name	= "imx-fiq-pcm-audio.0",
 	.codec_name	= "tlv320aic23-codec.0-001a",
 	.cpu_dai_name	= "imx-ssi.0",
 	.ops		= &eukrea_tlv320_snd_ops,


