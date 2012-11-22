Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2KWFqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:46:19 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56744 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2KWFqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:16 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <alsa-devel@alsa-project.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] ASoC: mxs-saif: export mxs_saif_put_mclk,mxs_saif_get_mclk
Date: Thu, 22 Nov 2012 13:31:09 +0100
Message-Id: <1353587470-11994-4-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/mxs/mxs-saif.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index c294fbb..f1d1f9e 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -229,6 +229,7 @@ int mxs_saif_put_mclk(unsigned int saif_id)
 	saif->mclk_in_use = 0;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mxs_saif_put_mclk);
 
 /*
  * Get MCLK and set clock rate, then enable it
@@ -282,6 +283,7 @@ int mxs_saif_get_mclk(unsigned int saif_id, unsigned int mclk,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mxs_saif_get_mclk);
 
 /*
  * SAIF DAI format configuration.
-- 
1.7.2.5

