Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1IBPEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:04:01 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39693 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab1IBPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:03:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] Input: twl6040-vibra: Use accessor to get revision information
Date: Fri,  2 Sep 2011 18:03:04 +0300
Message-Id: <1314975785-25081-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314975785-25081-1-git-send-email-peter.ujfalusi@ti.com>
References: <1314975785-25081-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
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

