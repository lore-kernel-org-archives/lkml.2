Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2KWFqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:46:49 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56745 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2KWFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:17 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <alsa-devel@alsa-project.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] ASoC: imx: add MODULE_LICENSE("GPL")
Date: Thu, 22 Nov 2012 13:31:07 +0100
Message-Id: <1353587470-11994-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also set MODULE_AUTHOR and MODULE_DESCRIPTION

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/fsl/imx-pcm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/imx-pcm.c b/sound/soc/fsl/imx-pcm.c
index 93dc360..d5cd9ef 100644
--- a/sound/soc/fsl/imx-pcm.c
+++ b/sound/soc/fsl/imx-pcm.c
@@ -103,3 +103,7 @@ void imx_pcm_free(struct snd_pcm *pcm)
 	}
 }
 EXPORT_SYMBOL_GPL(imx_pcm_free);
+
+MODULE_DESCRIPTION("Freescale i.MX PCM driver");
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_LICENSE("GPL");
-- 
1.7.2.5

