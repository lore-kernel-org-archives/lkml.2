Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1JJFH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:07:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1JJFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:07:27 -0400
From: Michael Opdenacker <michael.opdenacker@linaro.org>
To: jarkko.nikula@bitmer.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@linaro.org>
Subject: [PATCH 2/2] omap: sound: fix checkpatch.pl error
Date: Mon, 10 Oct 2011 07:07:08 +0200
Message-Id: <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org>
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@linaro.org>
---
 sound/soc/omap/omap-mcbsp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 1391ea0..30325fb 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -606,8 +606,7 @@ static int mcbsp_dai_probe(struct snd_soc_dai *dai)
 	return 0;
 }
 
-static struct snd_soc_dai_driver omap_mcbsp_dai =
-{
+static struct snd_soc_dai_driver omap_mcbsp_dai = {
 	.probe = mcbsp_dai_probe,
 	.playback = {
 		.channels_min = 1,
-- 
1.7.4.1

