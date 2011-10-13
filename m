Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1JMJRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:17:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51181 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1JMJRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:17:14 -0400
Subject: [PATCH] ASoC: ak4535: fixup cache register table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 17:17:06 +0800
Message-ID: <1318497427.2857.14.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ak4535_reg should be 8bit, but cache table is defined as 16bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4535.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 68df32d..95d782d 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -39,11 +39,11 @@ struct ak4535_priv {
 /*
  * ak4535 register cache
  */
-static const u16 ak4535_reg[AK4535_CACHEREGNUM] = {
-    0x0000, 0x0080, 0x0000, 0x0003,
-    0x0002, 0x0000, 0x0011, 0x0001,
-    0x0000, 0x0040, 0x0036, 0x0010,
-    0x0000, 0x0000, 0x0057, 0x0000,
+static const u8 ak4535_reg[AK4535_CACHEREGNUM] = {
+	0x00, 0x80, 0x00, 0x03,
+	0x02, 0x00, 0x11, 0x01,
+	0x00, 0x40, 0x36, 0x10,
+	0x00, 0x00, 0x57, 0x00,
 };
 
 static const char *ak4535_mono_gain[] = {"+6dB", "-17dB"};
-- 
1.7.4.1



