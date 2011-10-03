Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1JCDdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 23:33:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32797 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1JCDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 23:33:12 -0400
Subject: [PATCH] ASoC: Staticise ep93xx_ac97_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@iki.fi>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 11:33:05 +0800
Message-ID: <1317612785.5065.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/ep93xx/ep93xx-ac97.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
index c7417c7..3cd6158 100644
--- a/sound/soc/ep93xx/ep93xx-ac97.c
+++ b/sound/soc/ep93xx/ep93xx-ac97.c
@@ -335,7 +335,7 @@ static struct snd_soc_dai_ops ep93xx_ac97_dai_ops = {
 	.trigger	= ep93xx_ac97_trigger,
 };
 
-struct snd_soc_dai_driver ep93xx_ac97_dai = {
+static struct snd_soc_dai_driver ep93xx_ac97_dai = {
 	.name		= "ep93xx-ac97",
 	.id		= 0,
 	.ac97_control	= 1,
-- 
1.7.4.1



