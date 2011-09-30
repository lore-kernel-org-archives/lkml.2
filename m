Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1I3F5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:57:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1I3F5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:57:11 -0400
Subject: [PATCH] ASoC: sn95031: Do not use static variable for channel_index
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 13:56:59 +0800
Message-ID: <1317362219.6646.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to use static variable for channel_index.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sn95031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index adb85bf..02a4857 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -103,7 +103,7 @@ static int sn95031_initialize_adc(struct snd_soc_codec *sn95031_codec)
 {
 	int base_addr, chnl_addr;
 	int value;
-	static int channel_index;
+	int channel_index;
 
 	/* Index of the first channel in which the stop bit is set */
 	channel_index = find_free_channel(sn95031_codec);
-- 
1.7.4.1



