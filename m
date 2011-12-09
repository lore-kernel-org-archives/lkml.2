Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1LINiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:38:23 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64835 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1LINiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:38:18 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 4/5] ASoC: mxs: Add missing MODULE_LICENSE("GPL")
Date: Fri,  9 Dec 2011 14:38:11 +0100
Message-Id: <a541450341a475b27ef603c5a4a67f113ba7fa0c.1323436034.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
 <555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
 <42d1579aefe3a3025f16fb4e38a4acf6b72756f7.1323436034.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323436034.git.LW@KARO-electronics.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sound driver refuses to load as module, because of the missing
MODULE_LICENSE("GPL").
The file header indicates that the driver is indeed published under
the GPL.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/mxs/mxs-pcm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index dea5aa4..8646913 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -357,3 +357,5 @@ static void __exit snd_mxs_pcm_exit(void)
 	platform_driver_unregister(&mxs_pcm_driver);
 }
 module_exit(snd_mxs_pcm_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.5.6.5

