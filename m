Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1JBJmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:42:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47957 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1JBJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:42:39 -0400
Subject: [PATCH 2/3] ASoC: Staticise samsung_spdif_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Seungwhan Youn <sw.youn@samsung.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317548500.16362.0.camel@phoenix>
References: <1317548500.16362.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 17:42:30 +0800
Message-ID: <1317548550.16362.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/spdif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index 965b2bd..468cff1 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -341,7 +341,7 @@ static struct snd_soc_dai_ops spdif_dai_ops = {
 	.shutdown	= spdif_shutdown,
 };
 
-struct snd_soc_dai_driver samsung_spdif_dai = {
+static struct snd_soc_dai_driver samsung_spdif_dai = {
 	.name = "samsung-spdif",
 	.playback = {
 		.stream_name = "S/PDIF Playback",
-- 
1.7.4.1



