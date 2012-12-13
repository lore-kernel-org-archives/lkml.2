Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2LMPXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:23:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35552 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2LMPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/18] power: ab8500_charger: remove unused defines.
Date: Thu, 13 Dec 2012 15:21:39 +0000
Message-Id: <1355412102-14265-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Cleanup of the ab8500_charger driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_charger.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 7bfb02e..0ada459 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -115,11 +115,6 @@ enum ab8500_charger_link_status {
 	USB_STAT_CARKIT_1,
 	USB_STAT_CARKIT_2,
 	USB_STAT_ACA_DOCK_CHARGER,
-	USB_STAT_SAMSUNG_USB_PHY_DIS,
-	USB_STAT_SAMSUNG_USB_PHY_ENA,
-	USB_STAT_SAMSUNG_UART_PHY_DIS,
-	USB_STAT_SAMSUNG_UART_PHY_ENA,
-	USB_STAT_MOTOROLA_USB_PHY_ENA,
 };
 
 enum ab8500_usb_state {
-- 
1.7.9.5

