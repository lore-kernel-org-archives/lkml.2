Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1IBOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:33:33 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33610 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab1IBOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:33:30 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Input: twl6040-vibra: Use accessor to get revision information
Date: Fri,  2 Sep 2011 17:32:41 +0300
Message-Id: <1314973961-21187-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
References: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
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

