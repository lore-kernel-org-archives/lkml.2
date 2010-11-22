Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0KVAQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:16:03 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61011 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0KVAQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tNgfTchwPJxeCesDk5wQm4o6fU7YxBM2dkynRjqNZQolN6nccH52IC67KZkAcBlcLh
         6vPW/CIhDsi2eBzeVwSIad18Kf2h9fj1h6oohVfCIqfdmKfBZNemUEDEJboRlpaH9unk
         3oKOZjCFsvMVyjTPPPgoRJCUA19i8txjGV6ec=
Subject: [PATCH RESEND] ASoC: stac9766 - set reg_cache_default to
	stac9766_reg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Smirl <jonsmirl@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 08:20:54 +0800
Message-Id: <1290385254.6941.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this is missing during multi-component conversion.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This resend fixes the subject line of the patch.

 sound/soc/codecs/stac9766.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/stac9766.c b/sound/soc/codecs/stac9766.c
index 8aad3a2..04c5224 100644
--- a/sound/soc/codecs/stac9766.c
+++ b/sound/soc/codecs/stac9766.c
@@ -384,6 +384,7 @@ static struct snd_soc_codec_driver soc_codec_dev_stac9766 = {
 	.reg_cache_size = sizeof(stac9766_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_step = 2,
+	.reg_cache_default = stac9766_reg,
 };
 
 static __devinit int stac9766_probe(struct platform_device *pdev)
-- 
1.7.0.4



