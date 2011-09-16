Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1IPCqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 22:46:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47875 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1IPCqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 22:46:43 -0400
Subject: [PATCH 1/2] ASoC: wm8995: Return -EINVAL if device ID mismatch
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 10:46:33 +0800
Message-ID: <1316141193.21890.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8995.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 5ad873f..05f7795 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -1642,6 +1642,7 @@ static int wm8995_probe(struct snd_soc_codec *codec)
 
 	if (ret != 0x8995) {
 		dev_err(codec->dev, "Invalid device ID: %#x\n", ret);
+		ret = -EINVAL;
 		goto err_reg_enable;
 	}
 
-- 
1.7.4.1



