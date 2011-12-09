Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1LINiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:38:21 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64834 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1LINiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:38:18 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/5] ASoC: mxs: add .owner to struct snd_soc_card
Date: Fri,  9 Dec 2011 14:38:09 +0100
Message-Id: <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will prevent the module from being removed from underneath its
users

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/mxs/mxs-sgtl5000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mxs/mxs-sgtl5000.c b/sound/soc/mxs/mxs-sgtl5000.c
index 7fbeaec..db5c184 100644
--- a/sound/soc/mxs/mxs-sgtl5000.c
+++ b/sound/soc/mxs/mxs-sgtl5000.c
@@ -105,6 +105,7 @@ static struct snd_soc_dai_link mxs_sgtl5000_dai[] = {
 
 static struct snd_soc_card mxs_sgtl5000 = {
 	.name		= "mxs_sgtl5000",
+	.owner		= THIS_MODULE,
 	.dai_link	= mxs_sgtl5000_dai,
 	.num_links	= ARRAY_SIZE(mxs_sgtl5000_dai),
 };
-- 
1.5.6.5

