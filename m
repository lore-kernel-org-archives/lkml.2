Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab1IOMkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:42 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38146 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933505Ab1IOMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 03/17] Input: twl6040-vibra: Use accessor to get revision information
Date: Thu, 15 Sep 2011 15:39:25 +0300
Message-Id: <1316090379-30760-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/misc/twl6040-vibra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index c43002e..154b7a3 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -97,7 +97,7 @@ static void twl6040_vibra_enable(struct vibra_info *info)
 	}
 
 	twl6040_power(info->twl6040, 1);
-	if (twl6040->rev <= TWL6040_REV_ES1_1) {
+	if (twl6040_get_revid(twl6040) <= TWL6040_REV_ES1_1) {
 		/*
 		 * ERRATA: Disable overcurrent protection for at least
 		 * 3ms when enabling vibrator drivers to avoid false
-- 
1.7.6.1

