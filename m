Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1LHJpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:45:08 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:53831 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1LHJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:44:30 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v3 4/4] mmc: mxs-mmc: Add an appropriate MODULE_ALIAS
Date: Thu,  8 Dec 2011 10:44:16 +0100
Message-Id: <b1c45bfdbc9323b2a6c50ce213a3e895aeea2b2f.1323336236.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323336236.git.LW@KARO-electronics.de>
References: <cover.1323336236.git.LW@KARO-electronics.de>
 <1ebaeb7f7ed88b1d82f5fc3a01c0661f38e2a16d.1323336236.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323336236.git.LW@KARO-electronics.de>
 <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323336236.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323336236.git.LW@KARO-electronics.de>
References: <cover.1323336236.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/mmc/host/mxs-mmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 0003d03..1ba08ae 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -891,3 +891,4 @@ module_exit(mxs_mmc_exit);
 MODULE_DESCRIPTION("FREESCALE MXS MMC peripheral");
 MODULE_AUTHOR("Freescale Semiconductor");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mxs-mmc");
-- 
1.5.6.5

