Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab2JRRVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:21:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33653 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2JRRVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:21:04 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 4/4] mmc: core: sd.c: Fixed line over 80 chars
Date: Fri, 19 Oct 2012 02:19:20 +0900
Message-Id: <1350580760-3886-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350580760-3886-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350580760-3886-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed line over 80 characters per line.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 0622b9b..ff82b7d 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -758,7 +758,8 @@ try_again:
 	 */
 	if (!mmc_host_is_spi(host) && rocr &&
 	    ((*rocr & 0x41000000) == 0x41000000)) {
-		err = mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180, true);
+		err = mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180,
+					     true);
 		if (err) {
 			ocr &= ~SD_OCR_S18R;
 			goto try_again;
-- 
1.7.9.5

